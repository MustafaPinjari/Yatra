import type {
  ApiResponse,
  BusRoute,
  BusStop,
  VehicleTelemetry,
  AssistanceRequest,
  IncidentReport,
} from '@yatra/shared-types';

export class YatraApiClient {
  private baseUrl: string;
  private token?: string;

  constructor(options: { baseUrl?: string; token?: string } = {}) {
    this.baseUrl = options.baseUrl || 'http://localhost:8000/api/v1';
    this.token = options.token;
  }

  setToken(token: string) {
    this.token = token;
  }

  private async request<T>(endpoint: string, options: RequestInit = {}): Promise<ApiResponse<T>> {
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      ...(options.headers as Record<string, string>),
    };

    if (this.token) {
      headers['Authorization'] = `Bearer ${this.token}`;
    }

    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      ...options,
      headers,
    });

    if (!response.ok) {
      const errorBody = await response.json().catch(() => ({}));
      throw new Error(errorBody?.error?.message || `HTTP ${response.status}: ${response.statusText}`);
    }

    return response.json();
  }

  async getHealth() {
    return this.request<{ status: string; environment: string }>('/health');
  }

  async getSystemInfo() {
    return this.request<{ name: string; version: string; activeModules: string[] }>('/system/info');
  }

  async getRoutes() {
    return this.request<BusRoute[]>('/routes');
  }

  async getStops(params?: { lat?: number; lng?: number; radiusKm?: number }) {
    const query = new URLSearchParams();
    if (params?.lat) query.append('lat', params.lat.toString());
    if (params?.lng) query.append('lng', params.lng.toString());
    if (params?.radiusKm) query.append('radiusKm', params.radiusKm.toString());
    const queryString = query.toString() ? `?${query.toString()}` : '';
    return this.request<BusStop[]>(`/stops${queryString}`);
  }

  async getFleetTelemetry() {
    return this.request<VehicleTelemetry[]>('/operator/fleet/live');
  }

  async getIncidents() {
    return this.request<IncidentReport[]>('/operator/incidents');
  }

  async createAssistanceRequest(data: {
    stopId: string;
    routeId: string;
    assistanceType: string;
  }) {
    return this.request<AssistanceRequest>('/handshake/requests', {
      method: 'POST',
      body: JSON.stringify(data),
    });
  }
}

