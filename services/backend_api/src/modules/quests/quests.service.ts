import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';

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

function getXpForNextLevel(level: number): number {
  if (level >= LEVEL_THRESHOLDS.length) return LEVEL_THRESHOLDS[LEVEL_THRESHOLDS.length - 1];
  return LEVEL_THRESHOLDS[level];
}

@Injectable()
export class QuestsService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async getTodayQuests(userId: string) {
    try {
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      const { data: quests, error: questError } = await this.supabase
        .from('eco_quests')
        .select('*')
        .eq('is_active', true)
        .eq('quest_type', 'daily')
        .order('created_at', { ascending: true });

      if (questError) throw new Error(questError.message);

      const { data: progress, error: progressError } = await this.supabase
        .from('user_quest_progress')
        .select('*')
        .eq('user_id', userId)
        .gte('created_at', today.toISOString());

      if (progressError) throw new Error(progressError.message);

      const progressMap = new Map<string, any>();
      for (const p of progress || []) {
        progressMap.set(p.quest_id, p);
      }

      const enrichedQuests = (quests || []).map((quest) => {
        const p = progressMap.get(quest.id);
        return {
          id: quest.id,
          title: quest.title,
          description: quest.description,
          quest_type: quest.quest_type,
          xp_reward: quest.xp_reward,
          coin_reward: quest.coin_reward,
          difficulty: quest.difficulty,
          target_action: quest.target_action,
          target_count: quest.target_count,
          progress: p?.current_count || 0,
          completed: !!p?.completed_at,
        };
      });

      return { success: true, data: enrichedQuests };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async getAllQuests(userId: string) {
    try {
      const { data: quests, error: questError } = await this.supabase
        .from('eco_quests')
        .select('*')
        .eq('is_active', true)
        .order('quest_type')
        .order('created_at');

      if (questError) throw new Error(questError.message);

      const { data: progress, error: progressError } = await this.supabase
        .from('user_quest_progress')
        .select('*')
        .eq('user_id', userId);

      if (progressError) throw new Error(progressError.message);

      const progressMap = new Map<string, any>();
      for (const p of progress || []) {
        progressMap.set(p.quest_id, p);
      }

      const enrichedQuests = (quests || []).map((quest) => {
        const p = progressMap.get(quest.id);
        return {
          id: quest.id,
          title: quest.title,
          description: quest.description,
          quest_type: quest.quest_type,
          xp_reward: quest.xp_reward,
          coin_reward: quest.coin_reward,
          difficulty: quest.difficulty,
          target_action: quest.target_action,
          target_count: quest.target_count,
          progress: p?.current_count || 0,
          completed: !!p?.completed_at,
        };
      });

      return { success: true, data: enrichedQuests };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async getQuestHistory(userId: string, page = 1, limit = 20) {
    const offset = (page - 1) * limit;

    try {
      const { data, error, count } = await this.supabase
        .from('user_quest_progress')
        .select('*, eco_quests(*)', { count: 'exact' })
        .eq('user_id', userId)
        .not('completed_at', 'is', null)
        .order('completed_at', { ascending: false })
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

  async updateQuestProgress(userId: string, questId: string, increment = 1) {
    const { data: quest, error: questError } = await this.supabase
      .from('eco_quests')
      .select('*')
      .eq('id', questId)
      .single();

    if (questError || !quest) throw new NotFoundException('Quest not found');

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    let { data: existingProgress } = await this.supabase
      .from('user_quest_progress')
      .select('*')
      .eq('user_id', userId)
      .eq('quest_id', questId)
      .gte('created_at', today.toISOString())
      .single();

    if (existingProgress?.completed_at) {
      return {
        success: true,
        data: {
          quest,
          progress: existingProgress,
          xp_awarded: 0,
          coins_awarded: 0,
          leveled_up: false,
        },
      };
    }

    const newCount = (existingProgress?.current_count || 0) + increment;
    const completed = newCount >= quest.target_count;

    if (existingProgress) {
      const { error } = await this.supabase
        .from('user_quest_progress')
        .update({
          current_count: newCount,
          completed_at: completed ? new Date().toISOString() : null,
        })
        .eq('id', existingProgress.id);

      if (error) throw new Error(error.message);
    } else {
      const { error } = await this.supabase
        .from('user_quest_progress')
        .insert({
          user_id: userId,
          quest_id: questId,
          current_count: newCount,
          completed_at: completed ? new Date().toISOString() : null,
        });

      if (error) throw new Error(error.message);
    }

    let xpAwarded = 0;
    let coinsAwarded = 0;
    let leveledUp = false;

    if (completed) {
      xpAwarded = quest.xp_reward;
      coinsAwarded = quest.coin_reward;

      await this.supabase.from('eco_rewards').insert({
        user_id: userId,
        points: xpAwarded,
        coin_value: coinsAwarded,
        action: `quest_complete:${quest.target_action}`,
      });

      const { data: xpData } = await this.supabase
        .from('user_xp')
        .select('total_xp, level')
        .eq('user_id', userId)
        .single();

      const currentXp = (xpData?.total_xp || 0) + xpAwarded;
      const newLevel = getLevelFromXp(currentXp);

      await this.supabase.from('user_xp').upsert(
        { user_id: userId, total_xp: currentXp, level: newLevel, updated_at: new Date().toISOString() },
        { onConflict: 'user_id' },
      );

      leveledUp = newLevel > (xpData?.level || 1);
    }

    return {
      success: true,
      data: {
        quest,
        progress: { current_count: newCount, completed: completed },
        xp_awarded: xpAwarded,
        coins_awarded: coinsAwarded,
        leveled_up: leveledUp,
      },
    };
  }

  getLevelThresholds() {
    return { success: true, data: { thresholds: LEVEL_THRESHOLDS, getLevelFromXp, getXpForNextLevel } };
  }
}
