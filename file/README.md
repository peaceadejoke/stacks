# Dynamic NFT on Stacks — Phase 2

This project now includes two Clarity smart contracts:

1. **dynamic-nft.clar** — Core NFT with dynamic metadata  
2. **dynamic-nft-oracle.clar** — External trigger that updates the NFT state

The second contract acts like a trusted oracle, a scheduler, or a backend bridge for off-chain events.

---

## New Contract: `dynamic-nft-oracle.clar`

### Purpose
The oracle contract controls external values that affect NFT metadata.  
It stores a `latest-value` and pushes it into the NFT contract using:

(contract-call? .dynamic-nft update-state <value>)


### Features
- Admin-restricted value updates  
- Trigger method to sync state to NFT  
- Read-only data access  
- Supports automation (cron-like scripts) or price feed integration  

---

## Project Structure



dynamic-nft/
├── contracts/
│ ├── dynamic-nft.clar
│ └── dynamic-nft-oracle.clar
├── tests/
│ └── dynamic-nft_test.ts
├── Clarinet.toml
└── README.md


---

## How to Use the Oracle

### 1. Update the oracle’s internal value
```clarity
(contract-call? .dynamic-nft-oracle update-value u5)

2. Push the new value to the NFT
(contract-call? .dynamic-nft-oracle push-to-nft)

3. Retrieve updated token URI
(contract-call? .dynamic-nft get-token-uri u1)

Why This Architecture?

Separates metadata logic from event logic

Reduces attack surface

Easier to integrate with off-chain triggers

Cleaner upgrade paths

Matches real-world dynamic NFT design patterns

Next Steps (Phase 3 Options)

Add test suite

Add frontend (Stacks.js + React)

Add metadata server/API

Store multiple oracle states

Add NFT burn/transfer hooks
