import { Injectable, Inject } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';

@Injectable()
export class LeaderboardsService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async getFilteredLeaderboard(
    filterType: string = 'campus',
    filterValue?: string,
    limit: number = 50,
  ) {
    try {
      const { data, error } = await this.supabase.rpc(
        'get_filtered_leaderboard',
        {
          filter_type: filterType,
          filter_value: filterValue || null,
          result_limit: limit,
        },
      );

      if (error) throw new Error(error.message);

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async getFriendLeaderboard(userId: string, limit: number = 50) {
    try {
      const { data, error } = await this.supabase.rpc(
        'get_friend_leaderboard',
        {
          p_user_id: userId,
          result_limit: limit,
        },
      );

      if (error) throw new Error(error.message);

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async getHostelLeaderboard(college?: string, limit: number = 50) {
    try {
      const { data, error } = await this.supabase.rpc(
        'get_hostel_leaderboard',
        {
          p_college: college || null,
          result_limit: limit,
        },
      );

      if (error) throw new Error(error.message);

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async getPeriodLeaderboard(
    period: string = 'weekly',
    filterType: string = 'campus',
    filterValue?: string,
    limit: number = 50,
  ) {
    try {
      const { data, error } = await this.supabase.rpc(
        'get_period_leaderboard',
        {
          period,
          filter_type: filterType,
          filter_value: filterValue || null,
          result_limit: limit,
        },
      );

      if (error) throw new Error(error.message);

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async getUserRank(userId: string) {
    try {
      const { data, error } = await this.supabase.rpc(
        'get_filtered_leaderboard',
        {
          filter_type: 'campus',
          filter_value: null,
          result_limit: 999,
        },
      );

      if (error) throw new Error(error.message);

      const entry = data?.find((e: any) => e.user_id === userId);
      return {
        success: true,
        data: entry || { rank: 0, total_points: 0, level: 1 },
      };
    } catch (_) {
      return { success: true, data: { rank: 0, total_points: 0, level: 1 } };
    }
  }
}
