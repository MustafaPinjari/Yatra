# YATRA Trust Ledger (`blockchain/`)

Decentralized audit verification smart contracts deployed on Ethereum Sepolia testnet.

## Security & Privacy Guarantee

- **Zero PII On-Chain:** Passenger identities, location tracks, grievances, and photos are strictly prohibited from being written to the blockchain.
- **Cryptographic Fingerprints:** Only SHA-256 hashes of canonical inspection certificates and incident resolutions are anchored.

## Tooling & Verification

This module is designed for **Foundry**:
```bash
# Build contracts
forge build

# Run unit tests
forge test
```
*Note:* If Foundry (`forge`) is not locally installed on your workstation, you can install it via:
- Linux / macOS: `curl -L https://foundry.paradigm.xyz | bash && foundryup`
- Windows: via WSL2 or binary release.

