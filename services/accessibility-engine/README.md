# YATRA Accessibility Engine (`services/accessibility-engine`)

Manages the **AccessGraph** pedestrian and bus-stop accessibility spatial intelligence.

## Core Responsibilities

1. **Stop Accessibility Scoring:** Evaluates bus stops on curb heights, wheelchair ramps, tactile paving, shelters, and lighting (scores 0-100).
2. **Accessible Multi-Criteria Routing:** Connects pedestrian pathways to accessible boarding bays.
3. **Spatial Queries:** Uses PostGIS GIST indexes to compute accessibility-aware transit journeys.

