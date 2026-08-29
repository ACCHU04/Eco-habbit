import { Injectable, Inject } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import { ensureUserExists } from '../../common/helpers/user-sync.helper';
import {
  AppCacheService,
  CacheKeys,
} from '../../common/cache/cache.service';

export const POINTS_RULES: Record<string, number> = {
  list_item: 10,
  complete_sale: 50,
  complete_donation: 30,
  recycle_item: 20,
  post_community: 5,
  like_post: 1,
  comment_post: 2,
  ai_scan: 5,
  complete_diy: 40,
  refer_friend: 25,
};

export const COIN_RULES: Record<string, number> = {
  list_item: 2,
  complete_sale: 10,
  complete_donation: 5,
  recycle_item: 5,
  post_community: 1,
  like_post: 0,
  comment_post: 0,
  ai_scan: 1,
  complete_diy: 8,
  refer_friend: 5,
};

export const BADGE_CRITERIA: Record<
  string,
  { action: string; threshold: number }
> = {
  first_sale: { action: 'complete_sale', threshold: 1 },
  recycler: { action: 'recycle_item', threshold: 10 },
  creator: { action: 'complete_diy', threshold: 5 },
  community_star: { action: 'post_community', threshold: 10 },
  campus_champion: { action: 'complete_sale', threshold: 20 },
  eco_warrior: { action: 'recycle_item', threshold: 50 },
  upcycler: { action: 'complete_diy', threshold: 15 },
  donor: { action: 'complete_donation', threshold: 10 },
  marketplace_expert: { action: 'complete_sale', threshold: 50 },
  challenge_winner: { action: 'challenge_won', threshold: 1 },
  friend_maker: { action: 'friend_added', threshold: 5 },
  daily_warrior: { action: 'ai_scan', threshold: 30 },
  green_legend: { action: 'recycle_item', threshold: 100 },
};

export const ACHIEVEMENT_DEFINITIONS: Record<
  string,
  { title: string; description: string; target: number; icon: string }
> = {
  first_steps: { title: 'First Steps', description: 'Complete your first action', target: 1, icon: '🌱' },
  active_week: { title: 'Active Week', description: 'Earn points 7 days in a row', target: 7, icon: '🔥' },
  community_builder: { title: 'Community Builder', description: 'Create 20 community posts', target: 20, icon: '💬' },
  recycling_pro: { title: 'Recycling Pro', description: 'Recycle 100 items', target: 100, icon: '♻️' },
  marketplace_king: { title: 'Marketplace King', description: 'Complete 25 sales', target: 25, icon: '👑' },
  diy_master: { title: 'DIY Master', description: 'Complete 10 DIY projects', target: 10, icon: '🎨' },
  social_butterfly: { title: 'Social Butterfly', description: 'Add 10 friends', target: 10, icon: '🦋' },
  hostel_champion: { title: 'Hostel Champion', description: 'Win 3 hostel battles', target: 3, icon: '🏆' },
  challenge_crusher: { title: 'Challenge Crusher', description: 'Win 10 friend challenges', target: 10, icon: '💪' },
  eco_legend: { title: 'Eco Legend', description: 'Earn 10,000 total points', target: 10000, icon: '🌍' },
};

@Injectable()
export class RewardsService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
    private readonly cacheService: AppCacheService,
  ) {}

  async awardPoints(userId: string, action: string, customPoints?: number) {
    await ensureUserExists(this.supabase, userId);
    const points = customPoints ?? POINTS_RULES[action] ?? 0;
    if (points === 0) return { success: true, points: 0 };

    const coinValue = COIN_RULES[action] ?? 0;

    const { data, error } = await this.supabase
      .from('eco_rewards')
      .insert({
        user_id: userId,
        points,
        action,
        coin_value: coinValue,
      })
      .select()
      .single();

    if (error) throw new Error(error.message);

    await this.checkAndAwardBadges(userId);

    // Invalidate leaderboard caches (points changed rankings)
    await this.cacheService.invalidatePattern('leaderboard:');
    await this.cacheService.del(CacheKeys.home.dashboard(userId));

    return { success: true, data, points };
  }

  async getTotalPoints(userId: string) {
    try {
      const { data, error } = await this.supabase
        .from('eco_rewards')
        .select('points')
        .eq('user_id', userId);

      if (error) throw new Error(error.message);

      const total = data?.reduce((sum, r) => sum + r.points, 0) ?? 0;

      return { success: true, total_points: total };
    } catch (_) {
      return { success: true, total_points: 0 };
    }
  }

  async getPointsHistory(userId: string, page = 1, limit = 20) {
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
        pagination: {
          page,
          limit,
          total: 0,
          total_pages: 0,
        },
      };
    }
  }

  async getBadges(userId: string) {
    try {
      const { data, error } = await this.supabase
        .from('user_badges')
        .select('*')
        .eq('user_id', userId)
        .order('earned_at', { ascending: false });

      if (error) throw new Error(error.message);

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async getLeaderboard(limit = 50) {
    try {
      const { data, error } = await this.supabase.rpc('get_leaderboard', {
        result_limit: limit,
      });

      if (error) {
        const { data: fallback, error: fallbackError } = await this.supabase
          .from('eco_rewards')
          .select('user_id, points, users:user_id(id, full_name, profile_photo)')
          .order('created_at', { ascending: false })
          .limit(limit);

        if (fallbackError) throw new Error(fallbackError.message);

        const aggregated = (fallback || []).reduce((acc: any, r: any) => {
          const uid = r.user_id;
          if (!acc[uid]) {
            acc[uid] = {
              user_id: uid,
              total_points: 0,
              users: r.users,
            };
          }
          acc[uid].total_points += r.points;
          return acc;
        }, {});

        const leaderboard = Object.values(aggregated)
          .sort((a: any, b: any) => b.total_points - a.total_points)
          .slice(0, limit);

        return { success: true, data: leaderboard };
      }

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  private async checkAndAwardBadges(userId: string) {
    const { data: rewards } = await this.supabase
      .from('eco_rewards')
      .select('action')
      .eq('user_id', userId);

    if (!rewards) return;

    const actionCounts: Record<string, number> = {};
    for (const r of rewards) {
      actionCounts[r.action] = (actionCounts[r.action] || 0) + 1;
    }

    for (const [badgeType, criteria] of Object.entries(BADGE_CRITERIA)) {
      const count = actionCounts[criteria.action] || 0;
      if (count >= criteria.threshold) {
        await this.supabase
          .from('user_badges')
          .upsert(
            { user_id: userId, badge_type: badgeType },
            { onConflict: 'user_id,badge_type' },
          );
      }
    }
  }

  async getAchievements(userId: string) {
    try {
      const { data, error } = await this.supabase
        .from('user_achievements')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', { ascending: false });

      if (error) throw new Error(error.message);

      const achievements = Object.entries(ACHIEVEMENT_DEFINITIONS).map(
        ([key, def]) => {
          const existing = data?.find((a: any) => a.achievement_key === key);
          return {
            key,
            title: def.title,
            description: def.description,
            icon: def.icon,
            target: def.target,
            current: existing?.current_value || 0,
            completed: existing?.completed_at != null,
          };
        },
      );

      return { success: true, data: achievements };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async updateAchievementProgress(userId: string, achievementKey: string, increment: number = 1) {
    try {
      const def = ACHIEVEMENT_DEFINITIONS[achievementKey];
      if (!def) throw new Error('Unknown achievement');

      const { data: existing } = await this.supabase
        .from('user_achievements')
        .select('*')
        .eq('user_id', userId)
        .eq('achievement_key', achievementKey)
        .maybeSingle();

      const currentValue = (existing?.current_value || 0) + increment;

      if (existing) {
        const updateData: any = { current_value: currentValue };
        if (currentValue >= def.target && !existing.completed_at) {
          updateData.completed_at = new Date().toISOString();
        }

        await this.supabase
          .from('user_achievements')
          .update(updateData)
          .eq('id', existing.id);
      } else {
        const insertData: any = {
          user_id: userId,
          achievement_key: achievementKey,
          current_value: currentValue,
          target_value: def.target,
        };
        if (currentValue >= def.target) {
          insertData.completed_at = new Date().toISOString();
        }

        await this.supabase.from('user_achievements').insert(insertData);
      }

      return { success: true };
    } catch (_) {
      return { success: true };
    }
  }
}
