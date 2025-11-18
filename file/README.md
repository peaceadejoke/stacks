# Dynamic NFT Project (Final Phase)

This project implements a Dynamic NFT system on the Stacks blockchain, featuring:

- **Dynamic NFT contract**: NFTs whose metadata changes based on an external oracle.
- **Oracle contract**: Pushes updates to NFT state, with access control and history logging.
- **Metadata Registry contract**: Stores NFT metadata (title, description, image-url) with admin control.
- **Frontend Dashboard**: Displays NFTs, oracle values, and history. Allows admin interactions.

## **Setup**

1. Install Clarinet: `npm install -g @hirosystems/clarinet`
2. Run tests: `clarinet test`
3. Deploy contracts in dependency order:
   1. `dynamic-nft`
   2. `dynamic-nft-oracle`
   3. `dynamic-nft-metadata`
4. Connect the frontend wallet using Stacks.js.

## **Usage Examples**

### Admin Actions
- Update oracle: `update-value(new-value)`
- Push to NFT: `push-to-nft()`
- Set NFT metadata: `set-metadata(id, title, description, imageUrl)`
- Manage authorized callers: `add-authorized(who)`, `remove-authorized(who)`

### Read-Only Queries
- Latest oracle value: `get-latest-value()`
- History count: `get-history-count()`
- History by index: `get-history-by-index(index)`
- NFT metadata: `get-metadata(id)`

## **Security**
- Access control enforced via `admin` and `authorized-map`.
- Safe cross-contract calls with history logging only on success.
- Input validation on metadata to prevent empty or invalid values.

## **Project Structure**

contracts/
dynamic-nft.clar
dynamic-nft-oracle.clar
dynamic-nft-metadata.clar
frontend/
Dashboard.jsx
tests/
dynamic-nft_test.ts
dynamic-nft-oracle_test.ts
Clarinet.toml
README.md
