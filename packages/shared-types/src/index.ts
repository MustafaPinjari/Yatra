// ==============================================================================
// YATRA - Shared TypeScript Domain Models & Enums
// ==============================================================================

export type UserRole = 'COMMUTER' | 'DRIVER' | 'OPERATOR' | 'INSPECTOR' | 'ADMIN';

export type CrowdingTier = 'LOW' | 'MEDIUM' | 'HIGH' | 'OVERCROWDED';

export type AssistanceType =
  | 'WHEELCHAIR_RAMP'
  | 'VISION_ASSIST'
  | 'HEARING_ASSIST'
  | 'MOBILITY_TIME';

export type HandshakeStatus =
  | 'PENDING'
  | 'ACKNOWLEDGED'
  | 'BOARDING'
  | 'COMPLETED'
  | 'MISSED'
  | 'CANCELLED';

export type IncidentCategory =
  | 'BROKEN_RAMP'
  | 'IGNORED_HANDSHAKE'
  | 'OBSTRUCTED_CURB'
  | 'RUDE_BEHAVIOR'
  | 'OTHER';

export type IncidentSeverity = 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';

export interface GeoPoint {
  latitude: number;
  longitude: number;
}

export interface BusStop {
  id: string;
  gtfsStopId: string;
  nameEn: string;
  nameHi?: string;
  location: GeoPoint;
  accessibilityScore: number;
  hasWheelchairRamp: boolean;
  hasTactilePaving: boolean;
  hasShelter: boolean;
  curbHeightCm?: number;
}

export interface BusRoute {
  id: string;
  routeShortName: string;
  routeLongName: string;
  originName: string;
  destinationName: string;
  operatorCode: string;
}

export interface VehicleTelemetry {
  vehicleId: string;
  registrationNumber: string;
  routeId: string;
  coordinates: GeoPoint;
  speedKmh: number;
  crowdingTier: CrowdingTier;
  occupancyPercentage: number;
  isLowFloor: boolean;
  hasOperationalRamp: boolean;
  lastUpdated: string;
}

export interface AssistanceRequest {
  id: string;
  passengerId: string;
  stopId: string;
  routeId: string;
  assistanceType: AssistanceType;
  status: HandshakeStatus;
  createdAt: string;
  expiresAt: string;
  acknowledgedByDriverId?: string;
  estimatedArrivalSeconds?: number;
}

export interface IncidentReport {
  id: string;
  reporterId: string;
  vehicleId?: string;
  stopId?: string;
  category: IncidentCategory;
  severity: IncidentSeverity;
  rawDescription: string;
  aiStructuredSummary?: string;
  status: 'OPEN' | 'IN_INVESTIGATION' | 'RESOLVED' | 'CLOSED';
  createdAt: string;
}

export interface TrustRecord {
  id: string;
  entityType: 'INSPECTION' | 'INCIDENT_RESOLUTION';
  entityId: string;
  sha256Hash: string;
  ethereumTxHash?: string;
  blockNumber?: number;
  contractAddress: string;
  syncedAt: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
    details?: unknown;
  };
  metadata: {
    timestamp: string;
    version: string;
    requestId?: string;
  };
}

