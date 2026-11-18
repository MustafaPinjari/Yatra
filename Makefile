# ==============================================================================
# YATRA - Local Development Makefile
# ==============================================================================
# Prerequisites: Python 3.12+, Node.js 20+, Flutter 3.13+, Docker (optional)
# ==============================================================================

.PHONY: help setup dev test lint format migrate docker-up docker-down clean

help:
	@echo "YATRA Development Commands:"
	@echo "  make setup       - Initialize local virtualenv and npm dependencies"
	@echo "  make dev         - Run FastAPI backend and Operator Web concurrently"
	@echo "  make test        - Run backend test suite"
	@echo "  make lint        - Run Ruff and ESLint"
	@echo "  make format      - Format Python and frontend code"
	@echo "  make migrate     - Run Alembic database migrations"
	@echo "  make docker-up   - Start local PostgreSQL (PostGIS) and Redis containers"
	@echo "  make docker-down - Stop local development containers"
	@echo "  make clean       - Remove caches, temporary files, and test artifacts"

setup:
	@echo "--- Initializing Python Virtual Environment ---"
	python -m venv .venv || py -3.12 -m venv .venv
	@echo "--- Installing Python Backend Dependencies ---"
	.venv/bin/pip install --upgrade pip || .venv/Scripts/pip.exe install --upgrade pip
	.venv/bin/pip install -e "services/api[dev]" || .venv/Scripts/pip.exe install -e "services/api[dev]"
	@echo "--- Installing Web Dependencies ---"
	cd apps/operator-web && npm install

dev:
	@echo "Starting YATRA API backend on http://localhost:8000..."
	.venv/bin/uvicorn app.main:app --app-dir services/api --reload --port 8000 || .venv/Scripts/uvicorn.exe app.main:app --app-dir services/api --reload --port 8000

test:
	@echo "--- Running Backend Tests ---"
	.venv/bin/pytest services/api/app/tests -v || .venv/Scripts/pytest.exe services/api/app/tests -v

lint:
	@echo "--- Linting Python Code with Ruff ---"
	.venv/bin/ruff check services/api || .venv/Scripts/ruff.exe check services/api
	@echo "--- Linting Operator Web with ESLint ---"
	cd apps/operator-web && npm run lint

format:
	@echo "--- Formatting Python Code with Ruff ---"
	.venv/bin/ruff format services/api || .venv/Scripts/ruff.exe format services/api

migrate:
	@echo "--- Running Alembic Database Migrations ---"
	cd services/api && ../../.venv/bin/alembic upgrade head || cd services/api && ../../.venv/Scripts/alembic.exe upgrade head

docker-up:
	@echo "--- Starting Local Postgres (PostGIS) and Redis Containers ---"
	docker compose up -d

docker-down:
	@echo "--- Stopping Local Development Containers ---"
	docker compose down

clean:
	@echo "--- Cleaning Temporary Files and Caches ---"
	rm -rf .pytest_cache .ruff_cache __pycache__ apps/operator-web/.next

