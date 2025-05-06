# Mavrk - A Decentralized Finance Fair Launchpad

Welcome to the official GitHub repository for Mavrk — the decentralized token launchpad redefining how tokens go to market.

---

## 🌐 What is Mavrk?

Mavrk is a fair-launch, no-code token deployment platform that lets anyone instantly create and launch a cryptocurrency on-chain without requiring liquidity, coding knowledge, or pre-sale infrastructure.

Unlike platforms such as pump.fun or four.meme that use bonding curve models, Mavrk **eliminates the bonding curve phase entirely**, allowing tokens to be deployed **directly to a decentralized exchange (DEX)** like PancakeSwap or Uniswap V3.

### 🚀 Key Principles
- **No bonding curves**  
- **No trading taxes**  
- **No liquidity migration risks**  
- **$0 upfront liquidity required**  
- **One-time deployment fee only**  
- **Immutable smart contracts**  
- **LP positions auto-locked**

Mavrk currently supports **BNB Smart Chain** and **Base (Coinbase L2)** — both EVM-compatible chains. The contracts in this repository are structurally identical for both chains, with minor modifications for network-specific addresses (e.g., wrapped base assets).

---

## 📝 MavrkTokenStandard.sol

This is the base token contract used for all deployments through the Mavrk platform.

### ✅ Features
- **Immutable total supply** of `1,000,000,000` tokens (18 decimals)
- **No minting or burning functions**
- **No tax mechanisms**
- **No owner privileges or modifiable functions**
- **Token supply is minted to the deployer address on creation**
- Implements standard **ERC-20** functions:
  - `transfer`, `transferFrom`, `approve`, `allowance`, `balanceOf`, `totalSupply`, `name`, `symbol`, `decimals`

### 🔒 Safety
- Ownership is permanently renounced to `0x000000000000000000000000000000000000dEaD`
- Cannot be paused or upgraded
- Zero external dependency on off-chain systems

---

## 🔐 MavrkMultiLock.sol

This contract is responsible for **locking the LP position NFT** that gets created when a token is paired via PancakeSwap V3 (BNB) or Uniswap V3 (Base). It guarantees that liquidity cannot be withdrawn or manipulated post-deployment.

### ✅ Key Functions

- `lockLP(uint256 tokenId)`:  
  Accepts the V3 LP NFT and marks it as locked. Transfers custody of the NFT to this contract and permanently prevents its removal.

- `getLockedLPs()`:  
  Returns an array of all currently locked LP NFT token IDs.

- `getLocker(uint256 tokenId)`:  
  Returns the original locker (i.e., deployer address) that submitted the NFT for locking.

- `collectFees(uint256 tokenId)`:  
  Only callable by the Mavrk deployer address. Allows collection of trading fees accrued on the locked LP NFT (without unlocking or moving liquidity).

- `collectAllFees()`:  
  Collects fees across all locked positions in a single call (deployer-only).

### 🔒 Security & Permissions
- Only the deployer address (`0xa7597ded779806314544CBDabd1f38DE290677A2`) can call fee collection functions
- All fees are routed to the **Mavrk Treasury wallet** (`0x9f2cc0Af4cFCe8a65a08E103bd52AcB608E6948C`)
- LP positions cannot be withdrawn, transferred, or altered after locking
- Designed to work seamlessly across any EVM-compatible chain using V3-style LP NFTs

---

## 🧪 How to Use the Mavrk Platform

Mavrk is designed for creators of all experience levels — no code, no liquidity, no guesswork.

### 🔗 Supported Chains
- **BNB Smart Chain**
- **Base (Coinbase L2)**
- **Solana** *(Coming Soon)*

### 🚀 Launch Your Token (EVM Chains)

1. **Connect your wallet**  
   Go to [https://mavrk.xyz](https://mavrk.xyz) and click “Launch on BNB” or “Launch on BASE.” Connect using MetaMask or WalletConnect.

2. **Enter token details**  
   - Name and ticker  
   - Upload a PNG/JPEG logo  
   - (Optional) Add a website, description, and social links

3. **Pay the one-time deployment fee**  
   - **0.015 BNB** for BNB Smart Chain  
   - **0.000555 ETH** for Base Network

4. **Deploy**  
   After payment, click “Submit.” The Mavrk backend:
   - Deploys your token contract  
   - Initializes a PancakeSwap or Uniswap V3 liquidity pool  
   - Locks the LP NFT using the MavrkMultiLock contract

5. **Go live instantly**  
   Your token is verified and tradable immediately. You’ll receive:
   - Contract address  
   - Pool explorer links (Dexscreener, BscScan/BaseScan)  
   - Sharing tools for Twitter/X

---

## 📁 Repo Contents

- `MavrkTokenStandardBase.sol` – Token contract (used on both Base and BNB)
- `MavrkMultiLockBase.sol` – Liquidity locker contract (used on both Base and BNB)
- `MavrkTokenStandardBNB.sol` – Token contract (used on both Base and BNB)
- `MavrkMultiLockBNB.sol` – Liquidity locker contract (used on both Base and BNB)
- `README.md` – Project overview (this file)

---

## 📬 Contact & Links

- 🌐 Website: https://mavrk.xyz  
- 🧾 Whitepaper: https://s3.us-east-2.amazonaws.com/mavrk.xyz/Mavrk_Whitepaper_v1.pdf 
- 📢 Twitter: https://x.com/mavrkofficial  
- 💬 Telegram: https://t.me/mavrkofficial  
