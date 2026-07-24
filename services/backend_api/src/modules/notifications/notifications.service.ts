import { Injectable, Inject } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';

@Injectable()
export class NotificationsService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async getNotifications(
    userId: string,
    params: { unread_only?: boolean; page?: number; limit?: number },
  ) {
    const { unread_only, page = 1, limit = 20 } = params;
    const offset = (page - 1) * limit;

    try {
      let query = this.supabase
        .from('notifications')
        .select('*', { count: 'exact' })
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .range(offset, offset + limit - 1);

      if (unread_only) {
        query = query.is('read_at', null);
      }

      const { data, error, count } = await query;

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

  async markAsRead(userId: string, notificationId: string) {
    const { error } = await this.supabase
      .from('notifications')
      .update({ read_at: new Date().toISOString() })
      .eq('id', notificationId)
      .eq('user_id', userId);

    if (error) throw new Error(error.message);

    return { success: true };
  }

  async markAllAsRead(userId: string) {
    const { error } = await this.supabase
      .from('notifications')
      .update({ read_at: new Date().toISOString() })
      .eq('user_id', userId)
      .is('read_at', null);

    if (error) throw new Error(error.message);

    return { success: true };
  }

  async getUnreadCount(userId: string) {
    try {
      const { count, error } = await this.supabase
        .from('notifications')
        .select('id', { count: 'exact', head: true })
        .eq('user_id', userId)
        .is('read_at', null);

      if (error) throw new Error(error.message);

      return { success: true, unread_count: count || 0 };
    } catch (_) {
      return { success: true, unread_count: 0 };
    }
  }

  async getPreferences(userId: string) {
    const { data, error } = await this.supabase
      .from('notification_preferences')
      .select('*')
      .eq('user_id', userId)
      .single();

    if (error && error.code !== 'PGRST116') throw new Error(error.message);

    if (!data) {
      const { data: created, error: createError } = await this.supabase
        .from('notification_preferences')
        .insert({ user_id: userId })
        .select()
        .single();

      if (createError) throw new Error(createError.message);
      return { success: true, data: created };
    }

    return { success: true, data };
  }

  async updatePreferences(
    userId: string,
    prefs: {
      like_comment?: boolean;
      marketplace_inquiry?: boolean;
      reward_achievement?: boolean;
      community_update?: boolean;
    },
  ) {
    const { data, error } = await this.supabase
      .from('notification_preferences')
      .upsert(
        { user_id: userId, ...prefs, updated_at: new Date().toISOString() },
        { onConflict: 'user_id' },
      )
      .select()
      .single();

    if (error) throw new Error(error.message);

    return { success: true, data };
  }

  async createNotification(
    userId: string,
    type: string,
    title: string,
    body: string,
    data?: Record<string, any>,
  ) {
    const { data: notification, error } = await this.supabase
      .from('notifications')
      .insert({
        user_id: userId,
        type,
        title,
        body,
        data: data || null,
      })
      .select()
      .single();

    if (error) throw new Error(error.message);

    this.sendPushNotification(userId, { title, body, data });

    return { success: true, data: notification };
  }

  private async sendPushNotification(
    userId: string,
    payload: { title: string; body: string; data?: Record<string, any> },
  ) {
    try {
      const { data: user } = await this.supabase
        .from('users')
        .select('fcm_token')
        .eq('id', userId)
        .single();

      if (!user?.fcm_token) return;

      const { getMessaging } = await import('firebase-admin/messaging');

      const message = {
        token: user.fcm_token,
        notification: {
          title: payload.title,
          body: payload.body,
        },
        data: payload.data || {},
      };

      await getMessaging().send(message);
    } catch (_) {
      // Push notification is best-effort — don't fail the request
    }
  }
}
