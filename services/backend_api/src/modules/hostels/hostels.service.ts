import { Injectable, Inject } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import { ensureUserExists } from '../../common/helpers/user-sync.helper';

@Injectable()
export class HostelsService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async getAllHostels(college?: string) {
    try {
      let query = this.supabase
        .from('hostels')
        .select('*')
        .order('total_score', { ascending: false });

      if (college) query = query.eq('college', college);

      const { data, error } = await query;
      if (error) throw new Error(error.message);

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async getHostelById(hostelId: string) {
    try {
      const { data, error } = await this.supabase
        .from('hostels')
        .select('*')
        .eq('id', hostelId)
        .single();

      if (error || !data) throw new Error('Hostel not found');

      return { success: true, data };
    } catch (e: any) {
      return { success: false, error: e.message };
    }
  }

  async getHostelMembers(hostelName: string, limit: number = 50) {
    try {
      const { data, error } = await this.supabase
        .from('users')
        .select('id, full_name, profile_photo, college, department')
        .eq('hostel', hostelName)
        .limit(limit);

      if (error) throw new Error(error.message);

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async joinHostel(userId: string, hostelName: string) {
    await ensureUserExists(this.supabase, userId);

    try {
      const { data, error } = await this.supabase
        .from('users')
        .update({ hostel: hostelName })
        .eq('id', userId)
        .select()
        .single();

      if (error) throw new Error(error.message);

      return { success: true, data };
    } catch (e: any) {
      return { success: false, error: e.message };
    }
  }

  async getActiveBattles(hostelId?: string) {
    try {
      let query = this.supabase
        .from('hostel_battles')
        .select('*, hosteler:hosteler_id(id, name, avatar_url), challenger:hosteler_challenger(id, name, avatar_url)')
        .in('status', ['active', 'completed'])
        .order('created_at', { ascending: false });

      if (hostelId) {
        query = query.or(`hosteler_id.eq.${hostelId},hosteler_challenger.eq.${hostelId}`);
      }

      const { data, error } = await query;
      if (error) throw new Error(error.message);

      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async createBattle(
    title: string,
    description: string,
    hostelerId: string,
    challengerId: string,
    metric: string,
    durationDays: number,
  ) {
    try {
      const endsAt = new Date();
      endsAt.setDate(endsAt.getDate() + durationDays);

      const { data, error } = await this.supabase
        .from('hostel_battles')
        .insert({
          title,
          description,
          hosteler_id: hostelerId,
          hosteler_challenger: challengerId,
          metric,
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

  async getBattleById(battleId: string) {
    try {
      const { data, error } = await this.supabase
        .from('hostel_battles')
        .select('*, hosteler:hosteler_id(id, name, avatar_url), challenger:hosteler_challenger(id, name, avatar_url)')
        .eq('id', battleId)
        .single();

      if (error || !data) throw new Error('Battle not found');

      return { success: true, data };
    } catch (e: any) {
      return { success: false, error: e.message };
    }
  }
}
