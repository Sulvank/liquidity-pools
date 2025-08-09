// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {SwapApp} from "../src/SwapApp.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "./../src/interfaces/IV2Router02.sol";
import "./../src/interfaces/IFactory.sol";

contract SwapAppTest is Test {
    SwapApp app;
    address uniswapV2SwappRouterAddress = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24; // Uniswap V2 Router address on Ethereum mainnet
    address uniswapv2FactoryAddress = 0xf1D7CC64Fb4452F05c498126312eBE29f30Fbcf9; // Uniswap V2 Factory address on Ethereum mainnet
    address user = 0xEc02641ab94eA5CaDe82f0AFfa2b1Ec2C69272b5; // Address with USDT in Arbitrum Mainnet 
    address USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT address on Arbitrum mainnet
    address DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // DAI address on Arbitrum mainnet

    function setUp() public {
        app = new SwapApp(uniswapV2SwappRouterAddress,uniswapv2FactoryAddress, USDT, DAI);
    }

    function testHasBeenDeployedCorrectly() public view {
        assert(app.V2Router02Address() == uniswapV2SwappRouterAddress);
    }

    function testSwapTokensCorrectly() public {
        vm.startPrank(user);
        uint256 amountIn_ = 5 * 1e6;
        uint256 amountOutMin_ = 4 * 1e18; // Minimum amount of USDT to receive
        IERC20(USDT).approve(address(app), type(uint256).max);
        uint256 deadline_ = 1738499328 + 1000000000;
        address[] memory path_ = new address[](2);
        path_[0] = USDT; // Input token (USDT)
        path_[1] = DAI; // Output token (DAI)

        uint256 usdtBalanceBefore_ = IERC20(USDT).balanceOf(user);
        uint256 daiBalanceBefore_ = IERC20(DAI).balanceOf(user);
        app.swapTokens(amountIn_, amountOutMin_, path_, msg.sender, deadline_);
        uint256 usdtBalanceAfter_ = IERC20(USDT).balanceOf(user);
        uint256 daiBalanceAfter_ = IERC20(DAI).balanceOf(user);

        assert(usdtBalanceAfter_ == usdtBalanceBefore_ - amountIn_);
        assert(daiBalanceAfter_ >daiBalanceBefore_);

        vm.stopPrank();
    }

    function testCanAddLiquidityCorrectly() public {
        vm.startPrank(user);
        uint256 amountIn_ = 6 * 1e6; // Amount of USDT to add liquidity
        uint256 amountOutMin_ = 2 * 1e18; // Minimum amount of DAI to receive
        uint256 amountAMin_ = 0; // Minimum amount of USDT to add
        uint256 amountBMin_ = 0; // Minimum amount of DAI to add
        uint256 deadline_ = 1738499328 + 1000000000;
        address[] memory path_ = new address[](2);
        path_[0] = USDT; // Input token (USDT)
        path_[1] = DAI; // Output token (DAI)

        IERC20(USDT).approve(address(app), amountIn_);
        app.addLiquidity(amountIn_, amountOutMin_, path_, amountAMin_, amountBMin_, deadline_);

        vm.stopPrank();
    }

    function testRemoveLiquidity() public {
        vm.startPrank(user);
        uint256 amountIn_ = 6 * 1e6; // Amount of USDT to add liquidity
        uint256 amountOutMin_ = 2 * 1e18; // Minimum amount of DAI to receive
        uint256 amountAMin_ = 0; // Minimum amount of USDT to add
        uint256 amountBMin_ = 0; // Minimum amount of DAI to add
        uint256 deadline_ = 1738499328 + 1000000000;
        address[] memory path_ = new address[](2);
        path_[0] = USDT; // Input token (USDT)
        path_[1] = DAI; // Output token (DAI)

        // 1) Add liquidity (the user will receive LP tokens)
        IERC20(USDT).approve(address(app), amountIn_);
        app.addLiquidity(amountIn_, amountOutMin_, path_, amountAMin_, amountBMin_, deadline_);

        // 2) Locate the USDT-DAI LP token and approve the contract to spend them
        address lpToken = IFactory(uniswapv2FactoryAddress).getPair(USDT, DAI);

        uint256 lpBalance = IERC20(lpToken).balanceOf(user);
        require(lpBalance > 0, "No LP balance");

        // ✅ Approve the contract to move your LP tokens (no need to approve USDT/DAI to remove)
        IERC20(lpToken).approve(address(app), type(uint256).max);

        // 3) Choose an amount you actually have (for example, half)
        uint256 liquidityAmount_ = lpBalance / 2;
        uint256 amountAMintoRemove_ = 0;
        uint256 amountBMintoRemove_ = 0;
        address to_ = user;
        uint256 deadlinetoRemove_ = deadline_;

        // 4) Remove liquidity
        app.removeLiquidity(liquidityAmount_, amountAMintoRemove_, amountBMintoRemove_, to_, deadlinetoRemove_);

        vm.stopPrank();
    }
}
