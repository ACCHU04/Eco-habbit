export interface ImpactValues {
  co2: number;
  water: number;
  waste: number;
  energy: number;
}

export interface ImpactMetric {
  value: number;
  unit: string;
  label: string;
}

export interface ImpactResponse {
  impact: {
    co2: ImpactMetric;
    water: ImpactMetric;
    waste: ImpactMetric;
    energy: ImpactMetric;
  };
  actions: {
    items_recycled: number;
    items_sold: number;
    diy_completed: number;
    scans_completed: number;
  };
  level: number;
  total_xp: number;
}

export const IMPACT_RULES: Record<string, ImpactValues> = {
  recycle_item:      { co2: 1.2, water: 50,  waste: 1.5, energy: 2.0 },
  complete_sale:     { co2: 3.0, water: 120, waste: 3.5, energy: 5.0 },
  complete_diy:      { co2: 1.5, water: 30,  waste: 2.0, energy: 1.5 },
  ai_scan:           { co2: 0.3, water: 10,  waste: 0.4, energy: 0.5 },
  list_item:         { co2: 0.5, water: 20,  waste: 0.8, energy: 1.0 },
  complete_donation: { co2: 2.0, water: 80,  waste: 2.5, energy: 3.0 },
  post_community:    { co2: 0.1, water: 5,   waste: 0.1, energy: 0.2 },
  refer_friend:      { co2: 0.2, water: 8,   waste: 0.2, energy: 0.3 },
};
