// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {SwapApp} from "../src/SwapApp.sol";
import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract SwapAppTest is Test {
    SwapApp app;
    address uniswapV2SwappRouterAddress = 0x4752ba5DBc23f44D87826276BF6Fd6b1C372aD24; // Uniswap V2 Router address on Ethereum mainnet
    address user = 0xEc02641ab94eA5CaDe82f0AFfa2b1Ec2C69272b5; // Address with USDT in Arbitrum Mainnet 
    address USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9; // USDT address on Arbitrum mainnet
    address DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1; // DAI address on Arbitrum mainnet

    function setUp() public {
        app = new SwapApp(uniswapV2SwappRouterAddress);
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
        app.swapTokens(amountIn_, amountOutMin_, path_, deadline_);
        uint256 usdtBalanceAfter_ = IERC20(USDT).balanceOf(user);
        uint256 daiBalanceAfter_ = IERC20(DAI).balanceOf(user);

        assert(usdtBalanceAfter_ == usdtBalanceBefore_ - amountIn_);
        assert(daiBalanceAfter_ >daiBalanceBefore_);

        vm.stopPrank();
    }
}
