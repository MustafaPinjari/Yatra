# YATRA — Local Development Guide & Contributor Manual

**Document Version:** 1.0.0  
**Target Environment:** Local Workstation (Linux, macOS, Windows)  
**Author:** DevOps & Senior Full-Stack Engineer  

---

## 1. Prerequisites Checklist

Ensure the following tools are installed on your host machine:

| Tool | Minimum Version | Verification Command | Notes |
| :--- | :--- | :--- | :--- |
| **Python** | 3.12.x | `python --version` | Recommended installed at Python312 |
| **Node.js** | 20.x or 24.x | `node -v` | Includes `npm` and `npx` |
| **npm** | 10.x or 11.x | `npm -v` | Core package manager |
| **Flutter** | 3.13+ | `flutter --version` | Target for passenger and driver apps |
| **Dart** | 3.1+ | `dart --version` | Bundled with Flutter SDK |
| **Docker** | 24+ | `docker --version` | Optional, for local PostGIS/Redis |
| **Foundry** | 0.2.0+ | `forge --version` | Optional, for smart contracts |

---

## 2. Initial Monorepo Setup

```bash
# 1. Clone repository
git clone https://github.com/MustafaPinjari/Yatra.git
cd Yatra

# 2. Configure environment variables
# Copy .env.example to .env
cp .env.example .env      # Linux / macOS
copy .env.example .env    # Windows CMD
Copy-Item .env.example .env # Windows PowerShell
```

---

## 3. Backend Development (`services/api`)

### 3.1 Create Virtual Environment
```bash
# Using Python 3.12 explicitly
py -3.12 -m venv .venv

# Activate Virtual Environment:
# On Windows PowerShell:
.venv\Scripts\Activate.ps1
# On Linux / macOS:
source .venv/bin/activate
```

### 3.2 Install Dependencies
```bash
python -m pip install --upgrade pip
pip install -e "services/api[dev]"
```

### 3.3 Running the API Server
```bash
uvicorn app.main:app --app-dir services/api --reload --port 8000
```
- Interactive Swagger UI: `http://localhost:8000/docs`
- ReDoc Documentation: `http://localhost:8000/redoc`
- Health Probe: `http://localhost:8000/health`

### 3.4 Database Migrations (Alembic)
When running PostgreSQL with PostGIS:
```bash
cd services/api
alembic revision --autogenerate -m "create initial transit entities"
alembic upgrade head
```

---

## 4. Operator Web Dashboard (`apps/operator-web`)

```bash
cd apps/operator-web

# Install dependencies
npm install

# Start development server
npm run dev
```
Open [http://localhost:3000](http://localhost:3000) in your browser.

---

## 5. Mobile Applications (`apps/passenger-mobile` & `apps/driver-mobile`)

```bash
# Passenger Mobile
cd apps/passenger-mobile
flutter pub get
flutter run -d chrome  # Or target connected Android / iOS device

# Driver Assist Mobile
cd apps/driver-mobile
flutter pub get
flutter run -d chrome  # Or target connected tablet device
```

---

## 6. Smart Contracts (`blockchain/`)

```bash
cd blockchain

# Compile contracts
forge build

# Run unit tests
forge test

# Gas snapshot
forge snapshot
```

---

## 7. Quality Assurance & Testing

```bash
# Run Python backend unit tests
pytest services/api/app/tests -v

# Run Python linting and formatting
ruff check services/api
ruff format services/api

# Run TypeScript checks on Operator Web
cd apps/operator-web
npm run lint
npm run build
```

---

## 8. Common Troubleshooting

1. **PowerShell Script Execution Policy (`PSSecurityException`):**
   Run PowerShell as Administrator or invoke `.cmd` binaries directly (e.g. `npm.cmd`, `npx.cmd`). Alternatively set:
   ```powershell
   Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
   ```
2. **PostGIS Connection Refused:**
   Ensure PostgreSQL is running locally or start the development container:
   ```bash
   docker compose up -d
   ```
3. **Missing Google Gemini API Key:**
   If `GEMINI_API_KEY` is not provided in `.env`, the intelligence engine gracefully falls back to deterministic rule-based template generation without breaking the application.

