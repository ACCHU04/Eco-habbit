import { Injectable, Inject } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import { IMPACT_RULES, ImpactValues, ImpactResponse } from './passport.config';

const LEVEL_THRESHOLDS: number[] = [
  0, 100, 300, 600, 1000, 1500, 2200, 3000, 4000, 5200,
  6600, 8200, 10000, 12200, 14800, 17800, 21200, 25000, 29200, 34000,
];

function getLevelFromXp(totalXp: number): number {
  for (let i = LEVEL_THRESHOLDS.length - 1; i >= 0; i--) {
    if (totalXp >= LEVEL_THRESHOLDS[i]) return i + 1;
  }
  return 1;
}

@Injectable()
export class PassportService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async getImpact(userId: string): Promise<{ success: boolean; data: ImpactResponse }> {
    try {
      const { data: rewards, error } = await this.supabase
        .from('eco_rewards')
        .select('action, points, coin_value')
        .eq('user_id', userId);

      if (error) throw new Error(error.message);

      const totals: ImpactValues = { co2: 0, water: 0, waste: 0, energy: 0 };
      const actionCounts: Record<string, number> = {};

      for (const r of rewards || []) {
        actionCounts[r.action] = (actionCounts[r.action] || 0) + 1;
        const rules = IMPACT_RULES[r.action];
        if (rules) {
          totals.co2 += rules.co2;
          totals.water += rules.water;
          totals.waste += rules.waste;
          totals.energy += rules.energy;
        }
      }

      const { data: xpData } = await this.supabase
        .from('user_xp')
        .select('total_xp')
        .eq('user_id', userId)
        .single();

      const totalXp = xpData?.total_xp ?? 0;

      return {
        success: true,
        data: {
          impact: {
            co2: { value: Math.round(totals.co2 * 10) / 10, unit: 'kg', label: 'CO₂ Saved' },
            water: { value: Math.round(totals.water), unit: 'L', label: 'Water Saved' },
            waste: { value: Math.round(totals.waste * 10) / 10, unit: 'kg', label: 'Waste Diverted' },
            energy: { value: Math.round(totals.energy * 10) / 10, unit: 'kWh', label: 'Energy Saved' },
          },
          actions: {
            items_recycled: actionCounts['recycle_item'] || 0,
            items_sold: actionCounts['complete_sale'] || 0,
            diy_completed: actionCounts['complete_diy'] || 0,
            scans_completed: actionCounts['ai_scan'] || 0,
          },
          level: getLevelFromXp(totalXp),
          total_xp: totalXp,
        },
      };
    } catch (_) {
      return {
        success: true,
        data: {
          impact: {
            co2: { value: 0, unit: 'kg', label: 'CO₂ Saved' },
            water: { value: 0, unit: 'L', label: 'Water Saved' },
            waste: { value: 0, unit: 'kg', label: 'Waste Diverted' },
            energy: { value: 0, unit: 'kWh', label: 'Energy Saved' },
          },
          actions: {
            items_recycled: 0,
            items_sold: 0,
            diy_completed: 0,
            scans_completed: 0,
          },
          level: 1,
          total_xp: 0,
        },
      };
    }
  }

  async getTimeline(userId: string, page = 1, limit = 20) {
    const offset = (page - 1) * limit;

    try {
      const { data, error, count } = await this.supabase
        .from('eco_rewards')
        .select('*', { count: 'exact' })
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .range(offset, offset + limit - 1);

      if (error) throw new Error(error.message);

      return {
        success: true,
        data: data || [],
        pagination: {
          page,
          limit,
          total: count || 0,
          total_pages: Math.ceil((count || 0) / limit),
        },
      };
    } catch (_) {
      return {
        success: true,
        data: [],
        pagination: { page, limit, total: 0, total_pages: 0 },
      };
    }
  }

  async getStreak(userId: string) {
    try {
      const { data: rewards, error } = await this.supabase
        .from('eco_rewards')
        .select('created_at')
        .eq('user_id', userId)
        .order('created_at', { ascending: false });

      if (error) throw new Error(error.message);

      const uniqueDates = new Set<string>();
      for (const r of rewards || []) {
        const d = new Date(r.created_at);
        uniqueDates.add(`${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`);
      }

      const sortedDates = Array.from(uniqueDates).sort().reverse();

      const today = new Date();
      const todayStr = `${today.getFullYear()}-${String(today.getMonth() + 1).padStart(2, '0')}-${String(today.getDate()).padStart(2, '0')}`;

      let currentStreak = 0;
      let checkDate = new Date(today);

      if (!uniqueDates.has(todayStr)) {
        checkDate.setDate(checkDate.getDate() - 1);
      }

      while (true) {
        const dateStr = `${checkDate.getFullYear()}-${String(checkDate.getMonth() + 1).padStart(2, '0')}-${String(checkDate.getDate()).padStart(2, '0')}`;
        if (uniqueDates.has(dateStr)) {
          currentStreak++;
          checkDate.setDate(checkDate.getDate() - 1);
        } else {
          break;
        }
      }

      let longestStreak = 0;
      let tempStreak = 0;
      let prevDate: Date | null = null;

      for (const dateStr of [...uniqueDates].sort()) {
        const d = new Date(dateStr);
        if (prevDate) {
          const diff = (d.getTime() - prevDate.getTime()) / (1000 * 60 * 60 * 24);
          if (diff === 1) {
            tempStreak++;
          } else {
            longestStreak = Math.max(longestStreak, tempStreak);
            tempStreak = 1;
          }
        } else {
          tempStreak = 1;
        }
        prevDate = d;
      }
      longestStreak = Math.max(longestStreak, tempStreak, currentStreak);

      return {
        success: true,
        data: {
          current_streak: currentStreak,
          longest_streak: longestStreak,
          last_active_date: sortedDates[0] || null,
        },
      };
    } catch (_) {
      return {
        success: true,
        data: { current_streak: 0, longest_streak: 0, last_active_date: null },
      };
    }
  }
}
