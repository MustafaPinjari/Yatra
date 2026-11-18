# YATRA — Database Architecture & Entity Design

**Document Version:** 1.0.0  
**Storage Engine:** PostgreSQL 16 with PostGIS 3.4  
**Author:** Principal Software Architect  

---

## 1. Overview & Spatial Design Philosophy

YATRA's database is designed for high spatial fidelity, strict relational integrity, and rapid geospatial indexing. All spatial entities (bus stops, routes, vehicles, depots) are stored using PostGIS `geometry` types in the WGS 84 coordinate reference system (`SRID=4326`).

---

## 2. Entity Dictionary & Schemas

### 2.1 User & Authentication
- **`users`**: Core identity table.
  - `id`: UUID (Primary Key)
  - `phone_number`: VARCHAR(20) UNIQUE NOT NULL (primary login for Indian commuters/drivers)
  - `email`: VARCHAR(255) UNIQUE NULL
  - `password_hash`: VARCHAR(255) NOT NULL
  - `role`: ENUM ('COMMUTER', 'DRIVER', 'OPERATOR', 'INSPECTOR', 'ADMIN')
  - `is_active`: BOOLEAN DEFAULT TRUE
  - `created_at`: TIMESTAMPTZ DEFAULT NOW()
  - `updated_at`: TIMESTAMPTZ DEFAULT NOW()

### 2.2 Profiles
- **`passenger_profiles`**: User preferences and assistive configuration.
  - `id`: UUID (PK)
  - `user_id`: UUID (FK -> users.id, UNIQUE)
  - `preferred_language`: VARCHAR(10) DEFAULT 'hi' (e.g., 'hi', 'en', 'pa', 'ur')
  - `requires_ramp`: BOOLEAN DEFAULT FALSE
  - `requires_visual_assistance`: BOOLEAN DEFAULT FALSE
  - `requires_hearing_assistance`: BOOLEAN DEFAULT FALSE
  - `requires_extra_boarding_time`: BOOLEAN DEFAULT FALSE
  - `emergency_contact_phone`: VARCHAR(20) NULL
  - *Privacy Note:* Stored with strict encryption; never exposed in public APIs.

- **`driver_profiles`**: Driver credential and assignment metadata.
  - `id`: UUID (PK)
  - `user_id`: UUID (FK -> users.id, UNIQUE)
  - `badge_number`: VARCHAR(50) UNIQUE NOT NULL
  - `license_number`: VARCHAR(50) UNIQUE NOT NULL
  - `depot_id`: UUID (FK -> depots.id)
  - `current_vehicle_id`: UUID (FK -> vehicles.id, NULL)
  - `assigned_route_id`: UUID (FK -> bus_routes.id, NULL)
  - `shift_status`: ENUM ('OFF_DUTY', 'ON_DUTY', 'ON_BREAK')

- **`operators`**: Transit operator organizations (e.g., DTC, DIMTS).
  - `id`: UUID (PK)
  - `name`: VARCHAR(100) NOT NULL
  - `code`: VARCHAR(20) UNIQUE NOT NULL
  - `contact_email`: VARCHAR(255) NOT NULL

- **`depots`**: Physical bus depots and inspection facilities.
  - `id`: UUID (PK)
  - `operator_id`: UUID (FK -> operators.id)
  - `name`: VARCHAR(100) NOT NULL
  - `location`: GEOMETRY(Point, 4326) NOT NULL
  - `address`: TEXT NULL

### 2.3 Transit Network & Fleet
- **`vehicles`**: Municipal bus inventory.
  - `id`: UUID (PK)
  - `registration_number`: VARCHAR(20) UNIQUE NOT NULL (e.g., 'DL 1PD 1234')
  - `operator_id`: UUID (FK -> operators.id)
  - `depot_id`: UUID (FK -> depots.id)
  - `is_low_floor`: BOOLEAN NOT NULL DEFAULT FALSE
  - `has_wheelchair_ramp`: BOOLEAN NOT NULL DEFAULT FALSE
  - `ramp_operational`: BOOLEAN NOT NULL DEFAULT TRUE
  - `wheelchair_bay_capacity`: INT DEFAULT 1
  - `seating_capacity`: INT NOT NULL DEFAULT 35
  - `standing_capacity`: INT NOT NULL DEFAULT 25

- **`bus_routes`**: Transit routes matching GTFS `routes.txt`.
  - `id`: UUID (PK)
  - `operator_id`: UUID (FK -> operators.id)
  - `route_short_name`: VARCHAR(20) NOT NULL (e.g., '502', 'TMS(+)')
  - `route_long_name`: VARCHAR(255) NOT NULL
  - `origin_name`: VARCHAR(100) NOT NULL
  - `destination_name`: VARCHAR(100) NOT NULL
  - `polyline`: GEOMETRY(LineString, 4326) NULL

- **`bus_stops`**: Physical bus stop locations matching GTFS `stops.txt`.
  - `id`: UUID (PK)
  - `gtfs_stop_id`: VARCHAR(50) UNIQUE NOT NULL
  - `name_en`: VARCHAR(150) NOT NULL
  - `name_hi`: VARCHAR(150) NULL
  - `location`: GEOMETRY(Point, 4326) NOT NULL
  - `accessibility_score`: DECIMAL(4, 2) DEFAULT 0.00 (0.00 to 100.00)

- **`vehicle_locations`**: Real-time GPS telemetry time-series.
  - `id`: BIGSERIAL (PK)
  - `vehicle_id`: UUID (FK -> vehicles.id)
  - `route_id`: UUID (FK -> bus_routes.id, NULL)
  - `coordinates`: GEOMETRY(Point, 4326) NOT NULL
  - `speed_kmh`: DECIMAL(5, 2) NULL
  - `bearing`: DECIMAL(5, 2) NULL
  - `recorded_at`: TIMESTAMPTZ NOT NULL

### 2.4 Accessibility Intelligence (AccessGraph)
- **`accessibility_profiles`**: Stop-level physical infrastructure evaluation.
  - `id`: UUID (PK)
  - `stop_id`: UUID (FK -> bus_stops.id, UNIQUE)
  - `curb_height_cm`: DECIMAL(4, 1) NULL
  - `has_tactile_paving`: BOOLEAN DEFAULT FALSE
  - `has_shelter`: BOOLEAN DEFAULT FALSE
  - `has_wheelchair_ramp`: BOOLEAN DEFAULT FALSE
  - `ramp_slope_ratio`: DECIMAL(4, 2) NULL (e.g. 1:12 = 0.08)
  - `has_audio_announcements`: BOOLEAN DEFAULT FALSE
  - `has_braille_signage`: BOOLEAN DEFAULT FALSE
  - `lighting_quality`: ENUM ('POOR', 'ADEQUATE', 'EXCELLENT')
  - `last_audited_at`: TIMESTAMPTZ NULL

- **`accessibility_features`**: Specific individual assets tagged at stops or pedestrian connectors.
  - `id`: UUID (PK)
  - `stop_id`: UUID (FK -> bus_stops.id)
  - `feature_type`: ENUM ('RAMP', 'TACTILE_PATH', 'AUDIO_BEACON', 'BOARDING_BAY', 'CURB_CUT')
  - `location`: GEOMETRY(Point, 4326) NOT NULL
  - `status`: ENUM ('OPERATIONAL', 'OBSTRUCTED', 'DAMAGED')
  - `notes`: TEXT NULL

### 2.5 AccessHandshake (Passenger-to-Driver Communication)
- **`assistance_requests`**: Passenger boarding alert lifecycle.
  - `id`: UUID (PK)
  - `passenger_id`: UUID (FK -> users.id)
  - `stop_id`: UUID (FK -> bus_stops.id)
  - `route_id`: UUID (FK -> bus_routes.id)
  - `assistance_type`: ENUM ('WHEELCHAIR_RAMP', 'VISION_ASSIST', 'HEARING_ASSIST', 'MOBILITY_TIME')
  - `status`: ENUM ('PENDING', 'ACKNOWLEDGED', 'COMPLETED', 'MISSED', 'CANCELLED')
  - `expires_at`: TIMESTAMPTZ NOT NULL
  - `created_at`: TIMESTAMPTZ DEFAULT NOW()

- **`assistance_acknowledgements`**: Driver response record.
  - `id`: UUID (PK)
  - `request_id`: UUID (FK -> assistance_requests.id)
  - `driver_id`: UUID (FK -> driver_profiles.id)
  - `vehicle_id`: UUID (FK -> vehicles.id)
  - `acknowledged_at`: TIMESTAMPTZ DEFAULT NOW()
  - `eta_seconds_at_ack`: INT NULL

- **`assistance_outcomes`**: Post-boarding resolution logged upon departure.
  - `id`: UUID (PK)
  - `request_id`: UUID (FK -> assistance_requests.id)
  - `outcome`: ENUM ('SUCCESSFUL_BOARDING', 'PASSENGER_NOT_PRESENT', 'BUS_OVERCROWDED', 'RAMP_MALFUNCTION')
  - `passenger_rating`: SMALLINT NULL (1-5)
  - `feedback_notes`: TEXT NULL
  - `completed_at`: TIMESTAMPTZ DEFAULT NOW()

### 2.6 Operations, Crowd Intelligence & Trust Ledger
- **`crowd_observations`**: Historical and real-time occupancy estimates.
  - `id`: BIGSERIAL (PK)
  - `vehicle_id`: UUID (FK -> vehicles.id)
  - `route_id`: UUID (FK -> bus_routes.id)
  - `stop_id`: UUID (FK -> bus_stops.id)
  - `occupancy_tier`: ENUM ('LOW', 'MEDIUM', 'HIGH', 'OVERCROWDED')
  - `estimated_passenger_count`: INT NULL
  - `capacity_percentage`: DECIMAL(5, 2) NOT NULL
  - `source`: ENUM ('TICKETING_ESTIMATE', 'DRIVER_MANUAL', 'PASSENGER_CONSENSUS', 'ML_MODEL')
  - `observed_at`: TIMESTAMPTZ DEFAULT NOW()

- **`incident_reports`**: Passenger and driver reported accessibility grievances.
  - `id`: UUID (PK)
  - `reporter_id`: UUID (FK -> users.id)
  - `vehicle_id`: UUID (FK -> vehicles.id, NULL)
  - `stop_id`: UUID (FK -> bus_stops.id, NULL)
  - `incident_category`: ENUM ('BROKEN_RAMP', 'IGNORED_HANDSHAKE', 'OBSTRUCTED_CURB', 'RUDE_BEHAVIOR', 'OTHER')
  - `severity`: ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')
  - `raw_description`: TEXT NOT NULL
  - `ai_structured_summary`: TEXT NULL (Populated via Gemini)
  - `status`: ENUM ('OPEN', 'IN_INVESTIGATION', 'RESOLVED', 'CLOSED')
  - `resolution_notes`: TEXT NULL
  - `resolved_at`: TIMESTAMPTZ NULL

- **`accessibility_inspections`**: Depot maintenance checks.
  - `id`: UUID (PK)
  - `depot_id`: UUID (FK -> depots.id)
  - `vehicle_id`: UUID (FK -> vehicles.id)
  - `inspector_id`: UUID (FK -> users.id)
  - `ramp_functional`: BOOLEAN NOT NULL
  - `kneeling_mechanism_functional`: BOOLEAN NOT NULL
  - `wheelchair_belts_intact`: BOOLEAN NOT NULL
  - `audio_visual_displays_working`: BOOLEAN NOT NULL
  - `overall_passed`: BOOLEAN NOT NULL
  - `certificate_hash`: VARCHAR(66) NOT NULL (SHA-256 with 0x prefix)
  - `inspected_at`: TIMESTAMPTZ DEFAULT NOW()

- **`trust_records`**: Blockchain synchronization receipts.
  - `id`: UUID (PK)
  - `entity_type`: ENUM ('INSPECTION', 'INCIDENT_RESOLUTION')
  - `entity_id`: UUID NOT NULL
  - `sha256_hash`: VARCHAR(66) NOT NULL
  - `ethereum_tx_hash`: VARCHAR(66) NULL
  - `block_number`: BIGINT NULL
  - `contract_address`: VARCHAR(42) NOT NULL
  - `synced_at`: TIMESTAMPTZ DEFAULT NOW()

---

## 3. Spatial Indexing & Query Strategy

```sql
-- PostGIS GIST Indexes for sub-millisecond geofencing and nearest-stop queries
CREATE INDEX idx_bus_stops_geom ON bus_stops USING GIST (location);
CREATE INDEX idx_depots_geom ON depots USING GIST (location);
CREATE INDEX idx_vehicle_loc_geom ON vehicle_locations USING GIST (coordinates);
CREATE INDEX idx_vehicle_loc_time ON vehicle_locations (vehicle_id, recorded_at DESC);

-- Composite B-Tree indexes for fast handshake and live dispatch Lookups
CREATE INDEX idx_assistance_req_lookup ON assistance_requests (stop_id, route_id, status);
CREATE INDEX idx_crowd_obs_route_time ON crowd_observations (route_id, observed_at DESC);
```

