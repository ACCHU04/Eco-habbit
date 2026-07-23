import { Injectable, Inject } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async getProfile(userId: string) {
    const { data, error } = await this.supabase
      .from('users')
      .select('*')
      .eq('id', userId)
      .single();

    if (error || !data) {
      throw new Error('User not found');
    }

    return {
      success: true,
      data,
    };
  }

  async updateProfile(userId: string, dto: UpdateUserDto) {
    const { data, error } = await this.supabase
      .from('users')
      .update(dto)
      .eq('id', userId)
      .select()
      .single();

    if (error) {
      throw new Error(error.message);
    }

    return {
      success: true,
      data,
    };
  }

  async getUserById(userId: string) {
    const { data, error } = await this.supabase
      .from('users')
      .select('id, full_name, college, profile_photo, role, created_at')
      .eq('id', userId)
      .single();

    if (error || !data) {
      throw new Error('User not found');
    }

    return {
      success: true,
      data,
    };
  }

  async getUserStats(userId: string) {
    const { data: listings } = await this.supabase
      .from('marketplace_listings')
      .select('id', { count: 'exact' })
      .eq('seller_id', userId);

    const { data: points } = await this.supabase
      .from('user_points')
      .select('points')
      .eq('user_id', userId)
      .single();

    const { data: badges } = await this.supabase
      .from('user_badges')
      .select('badge_type')
      .eq('user_id', userId);

    return {
      success: true,
      data: {
        listings_count: listings?.length || 0,
        total_points: points?.points || 0,
        badges_count: badges?.length || 0,
        badges: badges?.map((b) => b.badge_type) || [],
      },
    };
  }

  async upsertFcmToken(userId: string, fcmToken: string | null) {
    const { error } = await this.supabase
      .from('users')
      .update({ fcm_token: fcmToken })
      .eq('id', userId);

    if (error) throw new Error(error.message);

    return { success: true };
  }
}
