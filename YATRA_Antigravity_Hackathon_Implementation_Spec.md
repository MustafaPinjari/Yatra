# YATRA Mobility Intelligence

## Antigravity implementation specification --- Delhi Transport Stack Hackathon 2026

**Status:** Research-informed implementation brief \| **Prepared:** 24
November 2026\
**Phase 1 focus:** Problem 2, Crowdedness-aware journey planner\
**Supporting engine:** Problem 1, bus travel-time model\
**Phase 2 modules:** Problems 3, 4 and 5

------------------------------------------------------------------------

# 1. Executive decision

YATRA should be one transport-intelligence platform with shared data
foundations and reusable analytical engines, not five disconnected
hackathon demos.

The competition has a hard phase distinction. Phase 1 teams choose
Problem 1 or Problem 2. The existing YATRA decision is to target
**Problem 2**. Build Problem 1's travel-time model as a supporting
engine because a credible crowdedness-aware planner also needs credible
journey durations. Keep its API and validation independently testable.
Design Problems 3, 4 and 5 as Phase 2 extensions.

Do not claim one Phase 1 prototype has completed all five judged
problems. The architecture can support all five; the submission must
identify its selected problem and prove it with real data and
validation.

**Product proposition:** YATRA is a data-grounded public-transport
intelligence and journey-planning platform for Delhi. Passengers compare
bus journeys using estimated travel time, expected crowding and
transparent confidence. Planners use the same GPS, ticketing, GTFS and
metro datasets for demand analysis, OD estimation, feeder planning and
segment-load analysis.

## 1.1 Evidence rules

-   A ticket sample is not a census of passengers on every bus.
-   Route/time demand is not live occupancy of a specific vehicle.
-   Metro station entry/exit marginals do not reveal each passenger's
    exact OD pair or train.
-   Generated imagery is not proof that a real stop has the depicted
    accessibility facilities.
-   A live-feed file timestamp is not the newest vehicle-observation
    timestamp.
-   Google Maps is a comparison baseline for Problem 1, not
    unquestionable ground truth.
-   Never invent capacities, bus assignments, charger locations, road
    widths, population, ridership totals or observed outcomes.
-   Every estimate must carry source, model version, coverage and
    uncertainty.

# 2. Hackathon requirements and YATRA scope

## 2.1 Problem 1 --- Real-time bus traffic model and journey planner

Inputs: October 2026 DTC historical GPS archive (one SQLite database per
day in a 7z archive), live GTFS-Realtime vehicle positions if actually
accessible, and static GTFS routes/stops/trips/stop
times/calendars/shapes.

Required: origin, destination and departure time API; one or more bus
journeys; access walk, boarding stop, route, alighting stop, transfers,
egress walk and total duration; time-sensitive estimates; technical
note; comparison against observed trips and Google Maps.

## 2.2 Problem 2 --- Crowdedness-aware journey planner

Inputs: about 4--5 weeks of e-ticketing/ETM records and static GTFS. The
supplied October ticket archive is described as approximately 2.56
million records, 66 MB compressed and 290 MB unpacked. The challenge
material says e-ticketing captures only about 3--4% of bus tickets.
Treat this as a sample, not a census.

Required: crowding estimates by route, direction, stop-to-stop segment
and time of day; journey planner showing crowding with travel time;
faster-versus-more-comfortable choice; reproducible pipeline, technical
note, limitations and peak/off-peak validation.

## 2.3 Problem 3 --- Public-transit OD matrix

Inputs: bus e-ticketing origin/destination sample, metro station
entry/exit data, static GTFS and stop/station locations; optional
documented zone/population/land-use data.

Required: stop- or zone-level OD matrices for peak/off-peak; documented
bus sample expansion; metro OD estimation method with assumptions;
separate bus/metro/combined estimates where supportable; uncertainty and
validation against available totals.

## 2.4 Problem 4 --- Metro feeder bus routes

Inputs: target metro stations, station demand, road network and
road-width evidence, existing bus services, traffic model, approximately
500 electric buses as a total planning constraint, and verified or
explicitly assumed vehicle/charging specifications.

Required: routes no longer than 7 km, road eligibility, stops and
GeoJSON, fleet allocation, headways, schedules, charging feasibility and
coverage metrics.

**Clarification required:** the phrase "roads wider than 6 metres on
each side" is ambiguous. Ask organizers whether this means total
carriageway width above 6 m, width available on each side, or another
definition. Do not encode an interpretation as official policy.

## 2.5 Problem 5 --- Metro and bus crowding estimation

Inputs: about one month of bus/metro AFC boarding and alighting data,
route/station sequence and capacities if supplied.

Required: segment load by direction and time band; capacity-normalised
crowding where capacity is known; documented missing-alighting and metro
path inference; reproducible outputs and peak-pattern validation.

# 3. Architecture

Audit the existing repository before modifying it. Preserve working
modules and API contracts. Use the existing YATRA stack where present.

## 3.1 Frontends

**Flutter passenger application** (`apps/passenger-mobile/`):
origin/destination search, bus journeys, travel-time/crowding
comparison, maps, route details, supported accessibility preferences and
assistance flows. Use native Flutter widgets, Riverpod and GoRouter
already selected. Do not embed a web app to simulate native screens.

**Next.js web application** (`apps/operator-web/`): operator and
government analytical workflows, model/data quality, route/segment
crowding, travel-time reliability, OD matrices, feeder optimization and
reports. Do not copy the phone UI into a desktop dashboard.

Share brand tokens, API contracts, terminology and design documentation.
Do not force Flutter and React to share UI components.

## 3.2 Backend and analytics

-   FastAPI + Pydantic for versioned APIs.
-   PostgreSQL/PostGIS for serving data and geospatial entities.
-   DuckDB + Polars over Parquet for large offline processing.
-   GeoPandas/Shapely and spatial indexes for spatial processing.
-   MapLibre for maps.
-   RAPTOR/Connection Scan or a well-defined time-dependent transit
    graph for journey planning.
-   Google OR-Tools CP-SAT for feeder/fleet/charger scheduling.
-   LightGBM/CatBoost only after robust baselines and leakage-safe
    validation.

Suggested logical modules (initially Python packages in one service are
acceptable; do not create unnecessary microservices):

  -----------------------------------------------------------------------
  Module                              Responsibility
  ----------------------------------- -----------------------------------
  `gtfs-engine`                       Parse, validate and normalize GTFS

  `gps-ingestion`                     Daily SQLite ingestion and quality
                                      profiling

  `map-matching`                      Match GPS to route shapes/road
                                      edges

  `travel-time-engine`                Segment travel-time distributions
                                      and live blending

  `ticketing-ingestion`               Normalize tickets and resolve
                                      stops/routes

  `crowding-engine`                   Segment flows, calibration,
                                      confidence and crowding

  `journey-planner`                   Access/egress, transit routing,
                                      transfers and alternatives

  `od-engine`                         Bus/metro OD estimation

  `feeder-optimizer`                  Candidate routes, coverage, fleet
                                      and charging

  `metro-load-engine`                 Metro path inference and segment
                                      loads

  `api`                               Validation, auth, response
                                      composition and model metadata
  -----------------------------------------------------------------------

## 3.3 Storage

1.  Raw source archives: immutable and outside Git.
2.  Analytical lake: compressed Parquet partitioned by date and data
    type; query with DuckDB/Polars.
3.  Serving store: Postgres/PostGIS for GTFS entities, route geometry,
    derived segment metrics, model metadata and API results.

The GPS archive is described as 16.1 GB compressed and about 124 GB
extracted. Check disk capacity first. Do not load all raw GPS into
Postgres. Inspect SQLite schema, then process one day at a time if
storage is constrained. Store checksums and manifests. Never commit raw
data, secrets or generated large datasets to Git.

# 4. Data access and mandatory audit

## 4.1 Source order

1.  Official Delhi Transport Stack datasets and API access.
2.  Exact hackathon archive plus its README/checksums.
3.  Official GTFS/GTFS-Realtime specifications.
4.  Documented spatial data such as OpenStreetMap, with licence and
    attribution review.
5.  Google Maps only for the prescribed benchmark.

Do not silently replace the official feed with an unofficial mirror.

## 4.2 Live DTC GPS discrepancy

The current Delhi Transport Stack catalogue lists static DTC/DoT GTFS
and a GTFS-RT feed with Cluster GPS included, while describing DTC GPS
as forthcoming. The hackathon brief separately advertises a historical
October DTC GPS archive. Verify historical archive access and live DTC
feed availability separately. Do not assume a live DTC feed exists
because the historical archive is downloadable.

## 4.3 GTFS audit

Inspect all supplied files, including `agency.txt`, `routes.txt`,
`trips.txt`, `stops.txt`, `stop_times.txt`, `calendar.txt`,
`calendar_dates.txt`, `shapes.txt` and optional files actually present.

Report file presence, encoding, row counts, duplicate keys, missing
references, malformed service times, trips without valid ordered stop
times, routes without trips, invalid stop coordinates, missing shapes,
duplicate stops, service dates and exceptions, direction/headsign
consistency, and route/stop name mismatches against ticketing.

Run the canonical MobilityData GTFS validator. GTFS times can exceed
`24:00:00` for trips after midnight. Parse them as service-day offsets,
not ordinary clock times.

## 4.4 GPS audit

Discover the actual SQLite schema. Do not assume the brief's field list
is the exact schema.

Report table names, schemas, rows/day, min/max timestamps, timezone,
unique vehicles/routes/trips, duplicates, nulls, invalid coordinates,
impossible jumps/speeds, timestamp gaps, observation density, route/trip
coverage and percentage matched to shapes/roads.

## 4.5 Ticket audit

Inspect actual columns and types. Profile passenger count, timestamp
range/timezone, route variants, stop-name variants, missing vehicle
number, invalid/duplicate records, same-origin-destination records,
direction ambiguity and GTFS mapping rate. Earlier project notes suggest
vehicle number may be missing in roughly half the rows; recalculate from
the real file.

Create: - `docs/data/DATA_AUDIT_REPORT.md` -
`docs/data/DATA_DICTIONARY.md` - `docs/data/DATA_QUALITY_ISSUES.csv` -
`data/manifests/` with source, retrieval date, filename, size, checksum
and schema version.

# 5. Problem 1 --- travel-time engine

## 5.1 Baseline model

Represent bus movement as ordered route/shape segments, optionally
linked to road-network edges. Estimate travel-time distributions by
route, direction, segment, time of day and day type. Start with median,
interquartile range or median absolute deviation, sample count and a
documented fallback hierarchy. Add exponentially weighted recent
observations only when freshness and sample thresholds pass.

Only introduce LightGBM/CatBoost if it improves a robust statistical
baseline on chronological holdouts.

## 5.2 GPS cleaning and matching

-   Sort by vehicle and timestamp.
-   Remove exact duplicates.
-   Reject invalid coordinates.
-   Detect impossible jumps using elapsed time, geodesic distance and
    plausible bus-speed bounds.
-   Split traces at long gaps, route changes and discontinuities.
-   Retain raw records and store cleaned data separately.
-   Match to GTFS shapes first using route/trip context and ordered
    progress.
-   For road-level matching, use an HMM-style matcher or Valhalla
    against OpenStreetMap.
-   Store match confidence; exclude low-confidence matches from
    training.

Nearest-point snapping alone is not reliable in dense urban areas with
parallel roads, flyovers and service roads. Valhalla's guidance stresses
continuous traces, suitable point density, timestamps and GPS accuracy.
Measure actual feed density before choosing settings.

## 5.3 Dwell and segment times

Separate moving time between adjacent stops from dwell time at stops and
terminal layover where possible. Dwell is part of passenger journey
time. Do not count a long stationary interval as road travel. If sparse
GPS cannot identify stop arrival precisely, treat the observation as
interval-censored and lower confidence.

## 5.4 Live/historical blend

For a requested segment/departure time: 1. Select same route/direction
and time/day bucket. 2. Compute robust historical baseline. 3. Find
recent valid live traversals for the same segment or nearby matched
edges. 4. Blend only when live sample count and observation age pass
configured thresholds. 5. Increase uncertainty for sparse/stale data. 6.
Fall back in order: route/time bucket → road segment/time bucket →
corridor/time bucket → route/day-type baseline → schedule-derived
estimate. 7. Return source, sample count, model version and confidence.

One live bus must not overwrite a stable historical distribution.

## 5.5 Validation

Use chronological train/validation/test dates, not random row splits.
Keep repeated vehicle/trip observations from leaking across partitions.

Metrics: MAE, median absolute error, WAPE/weighted MAE, P90 absolute
error, prediction-interval coverage and width. Break results down by
route, hour, day type, segment length and sample bucket.

Compare schedule, historical median, proposed model and Google Maps for
identical OD pairs, dates and departure times. Observed GPS-derived
trips are the primary target; Google Maps is a benchmark, not ground
truth. Record retrieval time and unavailable results. Respect Google
Maps terms; do not scrape or bulk harvest.

## 5.6 Travel-time API

`GET /api/v1/travel-times/segments`

Inputs: `route_id`, `direction_id`, `from_stop_id`, `to_stop_id`,
`depart_at`.

Return segment/stop pair, moving time, dwell time if modeled, total
time, P50/P90 or interval, sample count, model version, data freshness,
confidence and fallback source.

# 6. Problem 2 --- crowdedness engine (Phase 1 core)

## 6.1 What ticket data can prove

A ticket may identify passenger count, route, boarding stop, intended
alighting stop and time. If vehicle/trip identifiers are missing, it
does not identify a physical bus with certainty. The stated 3--4%
coverage is not necessarily a uniform sample.

The first model should estimate ticketed passenger flow by
route/direction/segment/time. It can become an estimate of total
passenger load only after defensible calibration. Do not claim exact
live occupancy of a named bus from aggregated e-ticket data.

## 6.2 Normalize records

Keep source ID or deterministic hash, timestamp in UTC and IST,
passenger count, raw and normalized route, raw and resolved
boarding/alighting stops, nullable vehicle number, ticket type, mapping
method/confidence and exclusion reason. Preserve raw values for audit.

## 6.3 Stop resolution

Normalize Unicode, case, whitespace and punctuation. Maintain a reviewed
alias dictionary. Candidate stops must be plausible on the stated route
and direction. If several candidates remain, mark ambiguous; do not
silently choose the nearest name. Version alias corrections and review
high-volume unresolved names.

## 6.4 Segment assignment

Build ordered stop sequences per route direction and route pattern from
GTFS. A ticket with boarding index `i` and alighting index `j`, where
`j > i`, contributes `passenger_count` to every segment `k` where
`i <= k < j`, only if both stops resolve and the route pattern/direction
is compatible.

For a segment/time group:

`ticketed_segment_flow = sum(passenger_count for valid ticket OD spans crossing that segment)`

This is a sample-flow measure until calibrated.

## 6.5 Trip association

Use vehicle/trip IDs where reliable. Otherwise infer candidates from
route, direction, timestamp, GTFS departure/stop times and GPS
stop-passage observations. Store assignment probability/confidence. Do
not assign a trip solely because a ticket timestamp is close to a
scheduled departure.

When linkage is weak, aggregate by route × direction × segment × time
bucket. Do not fabricate per-vehicle occupancy.

## 6.6 Calibration

Preferred hierarchy: 1. Official route/day/time boarding totals or ETM
totals with compatible definitions. 2. Trusted vehicle/route-level
operational totals. 3. Stratified calibration by route, direction, time
band, weekday/weekend and ticket type where aggregate controls exist. 4.
If no credible controls exist, publish relative ticketed-flow indices
and do not scale to absolute passenger totals.

Where compatible control margins exist, use raking/iterative
proportional fitting or constrained calibration. Keep factors by
stratum, flag extreme factors and validate on held-out days. Never
calibrate bus ticket records to metro totals.

Do not apply a universal 25× multiplier merely because the overall
sample share is stated as 4%.

## 6.7 Crowding labels

If bus capacity and fleet mix are verified, compute estimated
load/capacity and use documented thresholds from an authoritative
capacity standard or explicitly approved pilot policy.

If capacity is unavailable, use relative labels such as
`Lower expected demand`, `Moderate expected demand`,
`Higher expected demand`. Do not say `Seats available`, `Standing room`
or `Full`. Do not convert an index to passenger counts without
calibration.

## 6.8 Confidence

Confidence depends on valid ticket count, stop-resolution rate,
direction/pattern certainty, trip association, timestamp quality,
calibration availability and week-to-week stability. Explain the reason.
Do not show an arbitrary 0--100 score unless calibrated against actual
outcomes.

## 6.9 Passenger choices

Offer `Fastest`, `Less crowded` and `Balanced`. A transparent
generalized-cost function may be:

`cost = travel_time + crowding_penalty + transfer_penalty + walking_penalty`

Weights must be configurable and documented, not presented as
scientifically established. Show the travel-time/crowding trade-off.

# 7. Shared journey planner

Accept coordinates or stop names, departure timestamp, maximum walking
distance, maximum transfers and preference. Use `Asia/Kolkata` in the
user interface and UTC internally. Respect GTFS service-day times above
24:00.

Find candidate stops spatially, then calculate pedestrian-network
walking time where available. Straight-line distance is not walking
time. If pedestrian routing is missing, label the fallback. Exclude
paths as inaccessible only when verified accessibility data supports
that claim.

Use RAPTOR or Connection Scan, or a well-defined time-dependent transit
graph, over GTFS trip/stop-time data. RAPTOR is designed for
Pareto-optimal journeys across criteria such as arrival time and
transfer count. Generate candidates with access walk, wait, in-vehicle
time, dwell, transfer walk/wait and egress walk. Apply Problem 1's
time-dependent estimates without double-counting dwell already embedded
in observed stop-to-stop times. Prune dominated alternatives and cap
transfers.

`GET /api/v1/journeys?from=...&to=...&depart_at=...&preference=balanced`

Each result: journey ID, departure/arrival, total duration,
access/egress/wait/in-vehicle seconds, transfers, legs, route/stop
details, expected crowding and confidence, model versions, data
freshness and limitations.

# 8. Problem 3 --- OD matrix

Choose the zone system after inspecting data density. Produce stop-level
bus OD where mapping is reliable, then aggregate to a documented
hexagonal grid or administrative zones. Publish zone GeoJSON and
stop/station crosswalk. Avoid tiny cells that create mostly empty
estimates.

Bus tickets represent sampled bus legs, not necessarily complete
journeys. Expand only with compatible aggregate control totals. Account
for sample selection bias by route/time/area; if no credible control
totals exist, publish sampled OD and uncertainty instead of a citywide
total.

If metro data contains only station entry/exit marginals, it does not
directly provide paired OD journeys. Estimate a model-based matrix using
station marginals, network topology, generalized travel cost and a
documented prior; use a doubly constrained gravity/entropy-maximization
approach and iterative proportional fitting to align row/column totals.
Label it estimated, not observed. If paired AFC OD records become
available, use them as a stronger source.

Combine bus/metro only at aggregate zone/time level when definitions and
totals are compatible. Do not infer person-level transfers from unlinked
aggregate records.

Publish point estimate, uncertainty interval, observed/imputed share,
calibration method, row/column residuals and sensitivity to zone size
and model parameters.

# 9. Problem 4 --- feeder route and EV fleet optimization

Use hourly metro station entries/exits for temporal demand. Allocate
demand to nearby zones using documented population/land-use data if
available. Do not claim population coverage without a population source.

Build a directed road graph from a suitable source such as OSM with
source date, licence and attribution. Classify each edge as `eligible`,
`ineligible` or `unknown` for the organizer's confirmed width rule.
Missing width is not proof of compliance. A route labelled compliant
must not traverse unknown-width edges unless organizers explicitly
approve a proxy.

Generate candidate routes/loops from target stations: - Route length \<=
7 km. - Stops on existing or justified candidate locations. - Respect
road direction and turn restrictions where available. - Use
time-dependent travel time. - Avoid duplicating existing bus services
without a demonstrated gap. - Measure walking catchment on a pedestrian
network where possible.

Use OR-Tools CP-SAT or MILP. Objectives: maximize demand coverage;
maintain service frequency; minimize fleet/distance; reduce duplication;
ensure energy feasibility. Hard constraints: route length, eligible
edges, total fleet \<= 500, feasible cycle/headway, non-overlapping bus
duties, SOC reserve, charger count/power/time and depot/deadhead
movement.

Do not invent battery capacity, range, kWh/km, charger power, depot
locations or charging time. Obtain official parameters or run clearly
labelled scenarios. Produce GeoJSON routes, stops, fleet assignments,
headways, charging schedule, constraint audit and coverage report.

# 10. Problem 5 --- bus and metro segment load

For trip-level bus boarding/alighting:

`load_after_stop[s] = load_after_stop[s-1] + boardings[s] - alightings[s]`

If alighting is absent, use ticket OD spans only when boarding/alighting
stop data and trip assignment are sufficiently reliable. Otherwise
estimate route/direction/time segment flows, not exact vehicle loads.
Capacity-normalised load requires verified capacity.

For metro paired station OD, assign each OD pair to feasible paths on
the metro graph; where multiple paths exist, use timetable, transfer
count and generalized cost to assign probabilities. Accumulate passenger
flows on each segment by direction/time. If only station marginals
exist, use Problem 3's estimated OD and propagate uncertainty. Hourly
station totals cannot reveal exact train occupancy without train
schedules/headways and passenger arrival assumptions.

Return load or relative index, capacity/source if known, load factor if
valid, direction, time band, coverage, model version, interval and
observed/estimated/imputed status.

# 11. API surface

Use versioned, typed schemas.

  Endpoint                               Purpose
  -------------------------------------- --------------------------
  `GET /api/v1/health`                   Health
  `GET /api/v1/gtfs/routes`              Route search
  `GET /api/v1/gtfs/stops`               Stop search
  `GET /api/v1/journeys`                 Journey options
  `GET /api/v1/travel-times/segments`    Segment travel time
  `GET /api/v1/crowding/segments`        Crowding by segment/time
  `GET /api/v1/crowding/routes`          Route crowding summary
  `GET /api/v1/od-matrices`              OD matrix query
  `POST /api/v1/feeder-plans`            Feeder optimization job
  `GET /api/v1/feeder-plans/{plan_id}`   Optimization result
  `GET /api/v1/loads/segments`           Bus/metro segment load
  `GET /api/v1/models/{model_id}`        Model provenance

Analytical responses should include applicable `generated_at`,
`data_as_of`, source dataset IDs, model version, method, confidence,
sample count, limitations, `is_estimate` and `is_synthetic`. Use
explicit units and timezone-aware timestamps.

# 12. Validation plan

**Problem 1:** Create OD/time pairs covering peak, off-peak, weekday,
late evening, short/long trips and high/low frequency routes. Compare
observed GPS trip times, GTFS schedule, model and Google Maps at
identical times. Report MAE, median error, P90 error and prediction
interval coverage.

**Problem 2:** Hold out whole dates. Compare
route/direction/segment/time patterns; weekday/weekend; peak/off-peak;
high/low-volume strata; week-to-week stability; mapping and
trip-association rates. Without APC/occupancy ground truth, validate
ticket-flow consistency and pattern plausibility, not actual seats or
occupancy.

**Problem 3:** Check matrix row/column totals against available
marginals and known totals; hold out days/stations; test zone-size and
model-parameter sensitivity; report uncertainty in sparse cells.

**Problem 4:** Automated tests for route length, road eligibility, fleet
total, bus-duty overlaps, headways, SOC reserve, charger capacity/time
windows and coverage.

**Problem 5:** Check load totals against station/boarding totals,
non-negative and plausible loads, peak/direction patterns and
sensitivity to missing alightings/path assignment.

------------------------------------------------------------------------

# 13. Build sequence and acceptance gates

## Phase 0 --- repository and data audit

Deliver repository audit, data schema, GTFS validator report, GPS/ticket
quality reports and confirmed access. No model training on uninspected
data.

## Phase 1A --- Problem 2 baseline

Ticket normalization, stop/route resolver, ordered segments, ticketed
segment-flow aggregation, route/direction/time crowding, confidence and
tests. Every displayed estimate must be traceable to source records,
mappings and model version.

## Phase 1B --- Problem 1 supporting engine

GPS cleaning, shape/road matching, travel-time baseline, dwell
separation where feasible and temporal validation. Demonstrate
performance against simple baselines on held-out dates.

## Phase 1C --- planner and demo

Journey routing, walking access/egress, crowding/time alternatives, API
docs, Flutter passenger flow and Next.js analytical view. Demo must work
on real traceable data and label estimates honestly.

## Phase 2A --- Problem 3

Zone system, bus sample calibration, metro marginal OD estimation,
uncertainty and validation.

## Phase 2B --- Problem 4

Candidate route generation, road eligibility, demand coverage, fleet
scheduling, energy and charging feasibility.

## Phase 2C --- Problem 5

Bus/metro segment load, path inference, capacity normalisation and
validation.

Do not start Phase 2 optimization before its inputs and assumptions are
verified.

# 14. Engineering quality

Tests: GTFS/time parsing, service calendars, stop resolution, segment
indexing, ticket aggregation, GPS cleaning/matching, journey API
fixtures, crowding invariants and every feeder hard constraint.

Reproducibility: record input checksums, code/config versions, model
version, run time, date splits, exclusions, row counts and output
schema.

Privacy: do not expose raw vehicle/ticket IDs to public clients;
pseudonymize where linkage is required; do not log passenger-linked
movement histories; keep secrets out of Git. Never put personal or
sensitive records on-chain. If the YATRA trust-ledger idea remains, use
only non-sensitive hashes and verification metadata, outside the
model-critical path.

**DevOps boundary:** production deployment, Kubernetes, Terraform, CI/CD
and production monitoring are deferred. Local scripts, tests and
optional Docker Compose for local Postgres/PostGIS/Redis are acceptable.

# 15. Risks and organizer questions

  -----------------------------------------------------------------------
  Risk / unknown                      Action
  ----------------------------------- -----------------------------------
  DTC live GPS availability differs   Verify live feed and historical
  from historical archive claim       archive separately

  Ticket sample may be biased         Request sampling method and
                                      official route/time controls

  Vehicle number missing in some      Measure actual missingness;
  tickets                             aggregate when linkage is weak

  Stop names ambiguous                Build reviewed, versioned alias
                                      mapping

  Capacity unknown                    Use relative demand labels until
                                      verified

  Metro data may be marginals only    Confirm whether paired OD AFC
                                      records exist

  Road width metadata incomplete      Clarify 6 m rule; unknown width is
                                      not compliant

  Target stations not listed in brief Request target list

  EV parameters absent                Request specs or publish scenarios

  October data is one month           State temporal limits; do not claim
                                      seasonal coverage
  -----------------------------------------------------------------------

Ask organizers: 1. Is October GPS archive DTC-only, and is live DTC
GTFS-RT currently available? 2. Does ticket archive include ETM
transactions or only e-ticket transactions? What is the sampling
mechanism? 3. Are route/day/time boarding control totals available? 4.
Are vehicle capacities and fleet types available? 5. Is metro data
paired station OD or only entry/exit marginals? 6. What exactly does
"roads wider than 6 metres on each side" mean? 7. Which metro stations
are targets for Problem 4? 8. What battery, range, energy use, depot and
charger parameters should be used?

# 16. Instructions to Antigravity

Read this document fully. Audit the existing repository and real data
before writing model code. Preserve existing functionality and API
contracts. Confirm Problem 2 as Phase 1 competition focus. Implement
ticket-based segment flow and crowding first; implement Problem 1
travel-time as its supporting engine; integrate both in one bus planner.
Build Flutter passenger and Next.js analytical interfaces against real
API contracts. Design Phase 2 modules without claiming completion.

Do not: - Start with a static dashboard or UI redesign. - Multiply
tickets by 25 without sampling evidence. - Claim per-bus occupancy from
unlinked ticket records. - Claim exact metro OD from station
marginals. - Claim road compliance where width is unknown. - Assume 500
buses can run without duty/charging constraints. - Train complex ML
before baselines and temporal validation. - Add unnecessary
microservices or cloud infrastructure. - Replace the approved YATRA
Living Atlas identity. - Mark a model validated until held-out metrics
exist.

Maintain these files: -
`docs/architecture/YATRA_HACKATHON_SYSTEM_DESIGN.md` -
`docs/data/DATA_AUDIT_REPORT.md` - `docs/data/DATA_DICTIONARY.md` -
`docs/models/TRAVEL_TIME_MODEL.md` - `docs/models/CROWDING_MODEL.md` -
`docs/models/OD_MATRIX_METHOD.md` -
`docs/models/FEEDER_OPTIMIZATION_METHOD.md` -
`docs/models/METRO_BUS_LOAD_METHOD.md` -
`docs/validation/VALIDATION_PLAN.md` - `docs/api/API_REFERENCE.md` -
`docs/development/LOCAL_SETUP.md`

At each milestone report changed files, tests run, measured results,
limitations and next dependency. A screen existing is not proof that a
model works.

# 17. Research references

1.  Delhi Transport Stack Hackathon 2026:
    https://delhi.transportstack.in/hackathon/
2.  Delhi Transport Stack Data & Services:
    https://delhi.transportstack.in/data-services
3.  GTFS overview: https://gtfs.org/documentation/overview/
4.  GTFS Schedule reference:
    https://gtfs.org/documentation/schedule/reference/
5.  GTFS-Realtime vehicle positions:
    https://gtfs.org/documentation/realtime/feed-entities/vehicle-positions/
6.  GTFS validation: https://gtfs.org/getting-started/validate/
7.  Valhalla map matching:
    https://valhalla.github.io/valhalla/api/map-matching/api-reference/
8.  Delling, Pajor and Werneck, "Round-Based Public Transit Routing,"
    Transportation Science (2014):
    https://doi.org/10.1287/trsc.2014.0534
9.  Hussain, Bhaskar and Chung, "Transit OD matrix estimation using
    smartcard data: Recent developments and future research challenges,"
    Transportation Research Part C (2021):
    https://doi.org/10.1016/j.trc.2021.103044
10. Zhao et al., "Origin--destination matrix estimation for public
    transport: A multi-modal weighted graph approach," Transportation
    Research Part C (2024): https://doi.org/10.1016/j.trc.2024.104694
11. Özgün et al., "Estimation of alighting counts for public
    transportation vehicle occupancy levels using reverse direction
    boarding," Journal of Public Transportation (2023):
    https://doi.org/10.1016/j.jpubtr.2023.100070
12. Google Maps Routes API:
    https://developers.google.com/maps/documentation/routes
13. Google OR-Tools optimization:
    https://developers.google.com/optimization
14. "Interactive Optimization of Electric Bus Scheduling and Overnight
    Charging" (2025): https://www.mdpi.com/1996-1073/18/16/4440

These references inform the proposed methods; they do not replace
official Delhi data or organizer clarification.

# 18. Acceptance standard

A reviewer must be able to enter a real Delhi OD pair and departure
time, receive multiple bus journey options, inspect travel-time and
crowding estimates, and trace those estimates to source data and model
versions.

For Phase 1, the strongest proof is a reproducible Problem 2 crowding
model integrated into a working planner, supported by the Problem 1
travel-time engine. Phase 2 extends the same data foundation to OD
estimation, feeder optimization and metro/bus segment load. A polished
interface helps explain the result; it cannot compensate for an
unsupported model.
