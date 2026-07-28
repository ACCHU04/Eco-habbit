import { Injectable, Inject } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import { ensureUserExists } from '../../common/helpers/user-sync.helper';

@Injectable()
export class ChallengesService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async getFriends(userId: string) {
    try {
      const { data, error } = await this.supabase
        .from('friendships')
        .select(`
          id, status, created_at,
          requester:requester_id(id, full_name, profile_photo),
          addressee:addressee_id(id, full_name, profile_photo)
        `)
        .or(`requester_id.eq.${userId},addressee_id.eq.${userId}`)
        .eq('status', 'accepted');

      if (error) throw new Error(error.message);

      const friends = (data || []).map((f: any) => {
        const isRequester = f.requester?.id === userId;
        const friend = isRequester ? f.addressee : f.requester;
        return {
          friendship_id: f.id,
          friend,
          since: f.created_at,
        };
      });

      return { success: true, data: friends };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async sendFriendRequest(requesterId: string, addresseeId: string) {
    await ensureUserExists(this.supabase, requesterId);

    try {
      const { data: existing } = await this.supabase
        .from('friendships')
        .select('id, status')
        .or(
          `and(requester_id.eq.${requesterId},addressee_id.eq.${addresseeId}),and(requester_id.eq.${addresseeId},addressee_id.eq.${requesterId})`,
        )
        .maybeSingle();

      if (existing) {
        return {
          success: false,
          error: existing.status === 'accepted'
            ? 'Already friends'
            : 'Request already pending',
        };
      }

      const { data, error } = await this.supabase
        .from('friendships')
        .insert({
          requester_id: requesterId,
          addressee_id: addresseeId,
        })
        .select()
        .single();

      if (error) throw new Error(error.message);

      return { success: true, data };
    } catch (e: any) {
      return { success: false, error: e.message };
    }
  }

  async respondToFriendRequest(
    userId: string,
    friendshipId: string,
    accept: boolean,
  ) {
    try {
      const { data: request, error: reqError } = await this.supabase
        .from('friendships')
        .select('*')
        .eq('id', friendshipId)
        .eq('addressee_id', userId)
        .eq('status', 'pending')
        .single();

      if (reqError || !request) {
        throw new Error('Friend request not found');
      }

      const newStatus = accept ? 'accepted' : 'declined';

      const { data, error } = await this.supabase
        .from('friendships')
        .update({ status: newStatus })
        .eq('id', friendshipId)
        .select()
        .single();

      if (error) throw new Error(error.message);

      return { success: true, data };
    } catch (e: any) {
      return { success: false, error: e.message };
    }
  }

  async removeFriend(userId: string, friendshipId: string) {
    try {
      const { error } = await this.supabase
        .from('friendships')
        .delete()
        .eq('id', friendshipId)
        .or(`requester_id.eq.${userId},addressee_id.eq.${userId}`);

      if (error) throw new Error(error.message);

      return { success: true };
    } catch (e: any) {
      return { success: false, error: e.message };
    }
  }

  async getPendingRequests(userId: string) {
    try {
      const { data, error } = await this.supabase
        .from('friendships')
        .select(`
          id, created_at,
          requester:requester_id(id, full_name, profile_photo)
        `)
        .eq('addressee_id', userId)
        .eq('status', 'pending');

      if (error) throw new Error(error.message);

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async createChallenge(
    challengerId: string,
    challengeeId: string,
    title: string,
    description: string,
    goalAction: string,
    goalCount: number,
    durationDays: number,
    xpReward: number,
    coinReward: number,
  ) {
    await ensureUserExists(this.supabase, challengerId);

    try {
      const endsAt = new Date();
      endsAt.setDate(endsAt.getDate() + durationDays);

      const { data, error } = await this.supabase
        .from('friend_challenges')
        .insert({
          challenger_id: challengerId,
          challengee_id: challengeeId,
          title,
          description,
          goal_action: goalAction,
          goal_count: goalCount,
          xp_reward: xpReward,
          coin_reward: coinReward,
          ends_at: endsAt.toISOString(),
        })
        .select()
        .single();

      if (error) throw new Error(error.message);

      return { success: true, data };
    } catch (e: any) {
      return { success: false, error: e.message };
    }
  }

  async respondToChallenge(
    userId: string,
    challengeId: string,
    accept: boolean,
  ) {
    try {
      const { data: challenge, error: cError } = await this.supabase
        .from('friend_challenges')
        .select('*')
        .eq('id', challengeId)
        .eq('challengee_id', userId)
        .eq('status', 'pending')
        .single();

      if (cError || !challenge) {
        throw new Error('Challenge not found');
      }

      if (!accept) {
        const { error } = await this.supabase
          .from('friend_challenges')
          .update({ status: 'declined' })
          .eq('id', challengeId);

        if (error) throw new Error(error.message);
        return { success: true, data: { status: 'declined' } };
      }

      const { data, error } = await this.supabase
        .from('friend_challenges')
        .update({
          status: 'active',
          starts_at: new Date().toISOString(),
        })
        .eq('id', challengeId)
        .select()
        .single();

      if (error) throw new Error(error.message);

      return { success: true, data };
    } catch (e: any) {
      return { success: false, error: e.message };
    }
  }

  async getUserChallenges(userId: string, status?: string) {
    try {
      let query = this.supabase
        .from('friend_challenges')
        .select(`
          *,
          challenger:challenger_id(id, full_name, profile_photo),
          challengee:challengee_id(id, full_name, profile_photo)
        `)
        .or(`challenger_id.eq.${userId},challengee_id.eq.${userId}`)
        .order('created_at', { ascending: false });

      if (status) query = query.eq('status', status);

      const { data, error } = await query;
      if (error) throw new Error(error.message);

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async updateChallengeProgress(
    userId: string,
    challengeId: string,
    increment: number = 1,
  ) {
    try {
      const { data: challenge, error: cError } = await this.supabase
        .from('friend_challenges')
        .select('*')
        .eq('id', challengeId)
        .eq('status', 'active')
        .single();

      if (cError || !challenge) {
        throw new Error('Challenge not found or not active');
      }

      const isChallenger = challenge.challenger_id === userId;
      const isChallengee = challenge.challengee_id === userId;

      if (!isChallenger && !isChallengee) {
        throw new Error('Not part of this challenge');
      }

      const field = isChallenger ? 'challenger_progress' : 'challengee_progress';
      const newProgress = (isChallenger ? challenge.challenger_progress : challenge.challengee_progress) + increment;

      const updateData: any = { [field]: newProgress };

      if (newProgress >= challenge.goal_count) {
        updateData.status = 'completed';
        updateData.winner_id = userId;
      }

      const { data, error } = await this.supabase
        .from('friend_challenges')
        .update(updateData)
        .eq('id', challengeId)
        .select()
        .single();

      if (error) throw new Error(error.message);

      return { success: true, data };
    } catch (e: any) {
      return { success: false, error: e.message };
    }
  }

  async getChallengeById(challengeId: string) {
    try {
      const { data, error } = await this.supabase
        .from('friend_challenges')
        .select(`
          *,
          challenger:challenger_id(id, full_name, profile_photo),
          challengee:challengee_id(id, full_name, profile_photo)
        `)
        .eq('id', challengeId)
        .single();

      if (error || !data) throw new Error('Challenge not found');

      return { success: true, data };
    } catch (e: any) {
      return { success: false, error: e.message };
    }
  }

  async getChallengeHistory(userId: string, limit: number = 20) {
    try {
      const { data, error } = await this.supabase
        .from('friend_challenges')
        .select(`
          *,
          challenger:challenger_id(id, full_name, profile_photo),
          challengee:challengee_id(id, full_name, profile_photo)
        `)
        .or(`challenger_id.eq.${userId},challengee_id.eq.${userId}`)
        .eq('status', 'completed')
        .order('ends_at', { ascending: false })
        .limit(limit);

      if (error) throw new Error(error.message);

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }
}
