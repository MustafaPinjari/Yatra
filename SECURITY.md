# Security Policy for YATRA

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Core Security Principles

1. **Passenger Privacy First**: Passenger identities, medical conditions, specific disability details, and precise location histories are never stored in public or unencrypted logs.
2. **Deterministic & Auditable Boundaries**: Machine learning models and LLMs (Google Gemini) provide assistive insights and multilingual explanations only; all safety-critical operations and deterministic transit dispatch decisions remain in testable backend business logic.
3. **No Private Data On-Chain**: The YATRA Trust Ledger smart contracts store strictly SHA-256 cryptographic hashes and non-sensitive timestamps/inspector IDs for auditability. No PII, photos, or GPS tracks are ever written to the blockchain.
4. **Environment Isolation**: No credentials or private keys are ever committed to the repository.

## Reporting a Vulnerability

If you discover a security vulnerability in YATRA, please do NOT file a public issue.
Instead, send an email to: `security@yatra-platform.org` (or contact the maintainers directly).

Please include:
- A description of the vulnerability.
- Steps to reproduce or proof-of-concept.
- Potential impact.

We will acknowledge receipt within 48 hours and work on a remediation plan promptly.

