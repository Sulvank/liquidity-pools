# 🔄 SwapApp - Token Swap and Liquidity Management

**SwapApp** is a Solidity smart contract built with Foundry that integrates with Uniswap V2 to enable token swaps, liquidity provision, and liquidity removal. The project includes a complete testing suite for all core functionalities.

> **Note**
> This contract uses OpenZeppelin's `SafeERC20` library and Uniswap V2 Router & Factory interfaces for secure and reliable token handling.

---

## 🔹 Key Features

* ✅ **Token Swap** – Swap between ERC20 tokens using Uniswap V2.
* ✅ **Add Liquidity** – Provide liquidity to Uniswap pools by supplying token pairs.
* ✅ **Remove Liquidity** – Withdraw liquidity from Uniswap pools and receive underlying tokens.
* ✅ **Factory & Pair Retrieval** – Use Uniswap Factory to get token pair addresses dynamically.
* ✅ **Full Test Coverage** – Includes Foundry tests for swaps, liquidity addition, and removal.

---

## 📄 Contract Overview

| Item                | Description                                           |
| ------------------- | ----------------------------------------------------- |
| **Contract Name**   | `SwapApp`                                             |
| **Dependencies**    | OpenZeppelin `SafeERC20`, Uniswap V2 Router & Factory |
| **Functions**       | `swapTokens`, `addLiquidity`, `removeLiquidity`       |
| **Networks Tested** | Arbitrum Mainnet (via fork)                           |

---

## 🚀 How to Use Locally

### 1️⃣ Clone and Setup

```bash
git clone <your-repo-url>
cd <your-project-folder>
```

### 2️⃣ Install Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 3️⃣ Run Tests

```bash
forge test --fork-url https://arb1.arbitrum.io/rpc
```

> The tests use mainnet forking on Arbitrum to execute real Uniswap swaps and liquidity operations.

---

## 🧠 Project Structure

```
swapapp/
├── lib/                              # External dependencies (OpenZeppelin, Uniswap)
├── script/                           # Deployment scripts
├── src/
│   └── SwapApp.sol                   # Main contract implementation
├── test/
│   └── SwapApp.t.sol                  # Unit tests for swap, addLiquidity, removeLiquidity
├── foundry.toml                       # Foundry configuration
└── README.md                          # Project documentation
```

---

## 🔍 Contract Functions

| Function                                                                                                                               | Description                                                             |
| -------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| `swapTokens(uint256 amountIn_, uint256 amountOutMin_, address[] path_, address to_, uint256 deadline_)`                                | Swaps tokens via Uniswap V2 Router.                                     |
| `addLiquidity(uint256 amountIn_, uint256 amountOutMin_, address[] path_, uint256 amountAMin_, uint256 amountBMin_, uint256 deadline_)` | Swaps half of input tokens and provides liquidity to the USDT/DAI pool. |
| `removeLiquidity(uint256 liquidityAmount_, uint256 amountAMin_, uint256 amountBMin_, address to_, uint256 deadline_)`                  | Removes liquidity from the pool and sends tokens to the user.           |

---

## 🛠️ Potential Improvements

* 🔐 Add access controls for certain functions.
* 💰 Support for fee-on-transfer tokens.
* 🌐 Make token addresses configurable post-deployment.
* 📊 Emit detailed events for analytics.

---

## 🧪 Tests

The project includes Foundry-based tests covering:

* ✅ Token swap execution and balance changes.
* ✅ Adding liquidity and verifying LP token balances.
* ✅ Removing liquidity and receiving underlying tokens.

---

## 📜 License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---

### 🚀 SwapApp: Uniswap-powered token swap and liquidity management in Solidity.
