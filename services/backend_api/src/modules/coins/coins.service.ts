import { Injectable, Inject } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';

@Injectable()
export class CoinsService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async getBalance(userId: string) {
    try {
      const { data: xpData } = await this.supabase
        .from('user_xp')
        .select('total_xp, level')
        .eq('user_id', userId)
        .single();

      const { data: rewards } = await this.supabase
        .from('eco_rewards')
        .select('coin_value')
        .eq('user_id', userId);

      const balance = (rewards || []).reduce(
        (sum, r) => sum + (r.coin_value || 0),
        0,
      );

      return {
        success: true,
        data: {
          balance,
          level: xpData?.level || 1,
          total_xp: xpData?.total_xp || 0,
        },
      };
    } catch (_) {
      return {
        success: true,
        data: { balance: 0, level: 1, total_xp: 0 },
      };
    }
  }

  async getHistory(userId: string, page = 1, limit = 20) {
    const offset = (page - 1) * limit;

    try {
      const { data, error, count } = await this.supabase
        .from('eco_rewards')
        .select('*', { count: 'exact' })
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .range(offset, offset + limit - 1);

      if (error) throw new Error(error.message);

      const transactions = (data || []).map((r) => ({
        id: r.id,
        action: r.action,
        coin_value: r.coin_value || 0,
        points: r.points || 0,
        description: this.getActionDescription(r.action),
        created_at: r.created_at,
      }));

      return {
        success: true,
        data: transactions,
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

  private getActionDescription(action: string): string {
    const descriptions: Record<string, string> = {
      list_item: 'Listed an item for sale',
      complete_sale: 'Completed a marketplace sale',
      complete_donation: 'Made a donation',
      recycle_item: 'Recycled an item',
      post_community: 'Shared a community post',
      like_post: 'Liked a post',
      comment_post: 'Commented on a post',
      ai_scan: 'Scanned an item',
      complete_diy: 'Completed a DIY project',
      refer_friend: 'Referred a friend',
    };

    if (action.startsWith('quest_complete:')) {
      return `Completed a quest`;
    }

    return descriptions[action] || action;
  }
}
