# Dynamic NFT on Stacks (Clarity)

This project demonstrates a Dynamic NFT built on the Stacks blockchain using Clarity.  
The NFT updates its metadata or image based on an external factor such as a user action, time-based trigger, or price-feed update.

---

## Project Overview

Dynamic NFTs allow on-chain state changes that affect the token’s metadata.  
This contract maintains a base URI and a state variable that changes depending on an external event.  
The token URI returned to the frontend is computed from this changing state.

Examples of external triggers:
- A user interaction (e.g., upgrade event)
- A scheduled state update
- An oracle-driven price feed
- An admin-controlled event

---

## Folder Structure

dynamic-nft/
├── contracts/
│ └── dynamic-nft.clar
├── tests/
│ └── dynamic-nft_test.ts
├── Clarinet.toml
└── README.md


---

## Features

- NFT minting via Clarity’s `define-non-fungible-token`
- On-chain dynamic state tracking
- A token URI that changes based on the current state
- Admin-restricted update functions
- Simple and modular contract

---

## Requirements

- Clarinet
- Node.js (for writing tests)
- Git (optional)

Install Clarinet:

```bash
curl -fsSL https://get.hiro.so/clarinet/install.sh | sh
