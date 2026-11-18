# Contributing to YATRA

Thank you for your interest in contributing to **YATRA — Your Accessible Transport & Reliable Assistance Platform**!

## Development Philosophy

- **Universal Accessibility (a11y)**: Every feature must consider commuters with visual, motor, auditory, or cognitive disabilities. Screen-reader compatibility and WCAG 2.2 AA standards are non-negotiable.
- **Deterministic Core**: Transit schedules, trip planning, and driver handshakes must be rock-solid and deterministic.
- **Clean Architecture**: We maintain clean boundaries between frontend mobile apps, operator web, API services, and data engines.

## Getting Started

1. **Prerequisites**:
   - Python 3.12+
   - Node.js 20+ (with npm)
   - Flutter 3.13+
   - Git
2. **Setup**:
   - Follow instructions in [docs/development/DEVELOPMENT_GUIDE.md](docs/development/DEVELOPMENT_GUIDE.md).
   - Copy `.env.example` to `.env`.
3. **Branching & Commits**:
   - Branch names: `feat/<feature-name>`, `fix/<bug-name>`, `docs/<topic>`.
   - Use clear commit messages following Conventional Commits (`feat:`, `fix:`, `docs:`, `test:`).

## Code Style & Quality

- **Python**: Formatted and linted with `ruff check` and `ruff format`. Type checks with `mypy`.
- **TypeScript**: Formatted and checked with `eslint` and `prettier`.
- **Dart / Flutter**: Analyzed with `flutter analyze` and formatted with `dart format`.
- **Contracts**: Follow OpenZeppelin standards.

## Code of Conduct

Be welcoming, respectful, and mindful of diversity in physical and cognitive abilities. Our goal is making transit accessible for everyone.

