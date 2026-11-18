/**
 * @yatra/api-contracts
 * Canonical API endpoint contracts and request/response interfaces for YATRA.
 */

// 1. AccessHandshake Contracts
export interface InitiateHandshakeRequest {
  passenger_id: string;
  stop_id: string;
  route_id: string;
  trip_id?: string;
  assistance_type: 'WHEELCHAIR_RAMP' | 'VISUAL_ASSISTANCE' | 'HEARING_ASSISTANCE' | 'EXTRA_TIME';
  notes?: string;
  eta_target_seconds?: number;
}

export interface HandshakeStatusResponse {
  handshake_id: string;
  passenger_id: string;
  stop_id: string;
  stop_name: string;
  route_id: string;
  route_short_name: string;
  status: 'PENDING' | 'ACKNOWLEDGED' | 'RAMP_DEPLOYED' | 'BOARDED' | 'CANCELLED';
  driver_id?: string;
  vehicle_registration?: string;
  estimated_arrival_seconds: number;
  created_at: string;
  updated_at: string;
}

// 2. Journey Planner Contracts
export interface PlanJourneyRequest {
  origin_lat: number;
  origin_lon: number;
  destination_lat: number;
  destination_lon: number;
  accessible_only: boolean;
  transit_modes: Array<'BUS' | 'METRO' | 'WALK'>;
  max_transfers?: number;
  wheelchair_ramp_required?: boolean;
}

export interface RouteItineraryResponse {
  itinerary_id: string;
  summary: string;
  total_duration_minutes: number;
  walking_distance_meters: number;
  crowding_level: 'LOW' | 'MEDIUM' | 'HIGH';
  accessibility_score: number; // 0 - 100
  fare_inr: number;
  legs: Array<{
    mode: 'BUS' | 'METRO' | 'WALK';
    route_name?: string;
    from_stop: string;
    to_stop: string;
    duration_minutes: number;
    is_step_free: boolean;
    has_tactile_paving: boolean;
  }>;
}

// 3. Live Tracking Contracts
export interface LiveVehicleTelemetry {
  vehicle_id: string;
  route_id: string;
  route_short_name: string;
  latitude: number;
  longitude: number;
  heading_degrees: number;
  speed_kmh: number;
  current_stop_id: string;
  next_stop_id: string;
  eta_next_stop_seconds: number;
  is_low_floor: boolean;
  ramp_functional: boolean;
  crowding_level: 'LOW' | 'MEDIUM' | 'HIGH';
  occupancy_percent: number;
  timestamp: string;
}

// 4. AccessGraph Stop Rating Contracts
export interface AccessibleStopDetails {
  stop_id: string;
  stop_name: string;
  latitude: number;
  longitude: number;
  access_score: number; // 0 - 100
  has_ramp_boarding: boolean;
  has_tactile_paving: boolean;
  has_audio_announcements: boolean;
  has_shelter_seating: boolean;
  curb_height_cm: number;
  last_inspected_date: string;
  trust_ledger_tx?: string;
}
