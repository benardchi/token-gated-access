 Token-Gated Access Contract

A Clarity smart contract that enables token-based access control for decentralized applications (dApps) on the Stacks blockchain. This contract restricts or grants access to functions or content based on a user's ownership of a minimum threshold of a specified SIP-010 token.

---

 Overview

Token-Gated Access provides a reusable and configurable smart contract module to help developers:

- Gate premium features behind token ownership.
- Require NFT or token holdings to participate in exclusive functions.
- Implement membership or subscription logic based on token possession.

---

 Features

-  **SIP-010 Token Integration**: Compatible with all SIP-010 compliant fungible tokens (including wrapped NFTs).
-  **Access Control**: Functions can be protected with `require-access` checks.
-  **Configurable**: Admin can update token contract address and access threshold.
-  **Admin Controls**: Only the contract owner can modify access settings.

---

 Functionality

 Data Variables

- `admin`: The contract owner.
- `token-contract`: The SIP-010 token contract principal.
- `min-balance`: The minimum number of tokens required for access.

 Public Functions

- `set-token-contract (contract-principal principal)`: Admin sets the token used for gating.
- `set-min-balance (amount uint)`: Admin sets the minimum token balance required.
- `has-access (user principal)`: Checks if the user meets the access requirements.

---

 Example Use Case

Imagine a decentralized publishing platform where only token holders can view premium articles. By integrating this contract, the platform can:

- Specify a token (e.g., $PREMIUM-TOKEN).
- Set a minimum balance (e.g., 100 tokens).
- Use `has-access` in Clarity contracts to control article access.

---

 Interface

```clarity
(define-public (has-access (user principal)) (response bool uint))
(define-public (set-token-contract (contract-principal principal)) (response bool uint))
(define-public (set-min-balance (amount uint)) (response bool uint))
