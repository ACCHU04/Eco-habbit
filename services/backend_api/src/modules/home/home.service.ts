import { Injectable, Inject } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';

@Injectable()
export class HomeService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async getDashboard(userId: string) {
    const [userRes, statsRes, listingsRes] = await Promise.all([
      this.supabase
        .from('users')
        .select('id, full_name, college, profile_photo, role')
        .eq('id', userId)
        .single(),
      this.supabase.rpc('get_user_points', { p_user_id: userId }),
      this.supabase
        .from('marketplace_listings')
        .select('id, title, price, category, condition, marketplace_listing_images(image_url)')
        .eq('status', 'active')
        .order('created_at', { ascending: false })
        .limit(6),
    ]);

    return {
      success: true,
      data: {
        user: userRes.data,
        points: statsRes.data || 0,
        recent_listings: listingsRes.data || [],
      },
    };
  }
}
