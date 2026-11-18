# YATRA Core API Gateway (`services/api`)

FastAPI-powered asynchronous REST & WebSocket service powering the YATRA platform.

## Architecture

- **`app/core/config.py`**: Pydantic Settings reading environment variables with strict typing.
- **`app/core/logging.py`**: Structured JSON logging.
- **`app/api/v1/`**: Versioned API router definitions.
- **`app/models/`**: SQLAlchemy 2 ORM entities.
- **`app/schemas/`**: Pydantic v2 validation models.
- **`app/services/`**: Business logic implementations.
- **`app/repositories/`**: Database queries and persistence abstractions.
- **`app/integrations/`**: External connectors (Google Gen AI Gemini SDK, Redis Pub/Sub, Sepolia RPC).
- **`app/middleware/`**: CORS, request-ID tracing, and structured error envelopes.
- **`app/db/session.py`**: Asynchronous SQLAlchemy engine and session factories.

## Running Locally

```bash
# Activate environment
.venv\Scripts\Activate.ps1   # Windows
source .venv/bin/activate    # Linux / macOS

# Start service
uvicorn app.main:app --reload --port 8000
```
Open [http://localhost:8000/docs](http://localhost:8000/docs) for interactive OpenAPI docs.

