import {
  Injectable,
  Inject,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import { ensureUserExists } from '../../common/helpers/user-sync.helper';
import { CreateListingDto, UpdateListingDto } from './dto/listing.dto';

@Injectable()
export class MarketplaceService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async createListing(sellerId: string, dto: CreateListingDto) {
    await ensureUserExists(this.supabase, sellerId);
    const { image_urls, ...listingData } = dto;

    const { data: listing, error } = await this.supabase
      .from('marketplace_listings')
      .insert({ ...listingData, seller_id: sellerId })
      .select()
      .single();

    if (error) throw new Error(error.message);

    if (image_urls && image_urls.length > 0) {
      const images = image_urls.map((url, idx) => ({
        listing_id: listing.id,
        image_url: url,
        sort_order: idx,
      }));

      const { error: imgError } = await this.supabase
        .from('marketplace_listing_images')
        .insert(images);

      if (imgError) throw new Error(imgError.message);
    }

    return { success: true, data: listing };
  }

  async getListings(params: {
    search?: string;
    category?: string;
    condition?: string;
    min_price?: number;
    max_price?: number;
    page?: number;
    limit?: number;
  }) {
    const {
      search,
      category,
      condition,
      min_price,
      max_price,
      page = 1,
      limit = 20,
    } = params;
    const offset = (page - 1) * limit;

    try {
      let query = this.supabase
        .from('marketplace_listings')
        .select('*, marketplace_listing_images(image_url, sort_order)', {
          count: 'exact',
        })
        .eq('status', 'active')
        .order('created_at', { ascending: false })
        .range(offset, offset + limit - 1);

      if (search) {
        query = query.or(`title.ilike.%${search}%,description.ilike.%${search}%`);
      }
      if (category) {
        query = query.eq('category', category);
      }
      if (condition) {
        query = query.eq('condition', condition);
      }
      if (min_price !== undefined) {
        query = query.gte('price', min_price);
      }
      if (max_price !== undefined) {
        query = query.lte('price', max_price);
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

  async getListingById(id: string) {
    const { data, error } = await this.supabase
      .from('marketplace_listings')
      .select(
        '*, marketplace_listing_images(image_url, sort_order), users(id, full_name, profile_photo, college)',
      )
      .eq('id', id)
      .single();

    if (error || !data) throw new NotFoundException('Listing not found');

    return { success: true, data };
  }

  async updateListing(id: string, sellerId: string, dto: UpdateListingDto) {
    const { data: existing } = await this.supabase
      .from('marketplace_listings')
      .select('seller_id')
      .eq('id', id)
      .single();

    if (!existing) throw new NotFoundException('Listing not found');
    if (existing.seller_id !== sellerId)
      throw new ForbiddenException('Not your listing');

    const { data, error } = await this.supabase
      .from('marketplace_listings')
      .update(dto)
      .eq('id', id)
      .select()
      .single();

    if (error) throw new Error(error.message);

    return { success: true, data };
  }

  async deleteListing(id: string, sellerId: string) {
    const { data: existing } = await this.supabase
      .from('marketplace_listings')
      .select('seller_id')
      .eq('id', id)
      .single();

    if (!existing) throw new NotFoundException('Listing not found');
    if (existing.seller_id !== sellerId)
      throw new ForbiddenException('Not your listing');

    const { error } = await this.supabase
      .from('marketplace_listings')
      .update({ status: 'removed' })
      .eq('id', id);

    if (error) throw new Error(error.message);

    return { success: true, message: 'Listing removed' };
  }

  async getMyListings(sellerId: string) {
    const { data, error } = await this.supabase
      .from('marketplace_listings')
      .select('*, marketplace_listing_images(image_url, sort_order)')
      .eq('seller_id', sellerId)
      .neq('status', 'removed')
      .order('created_at', { ascending: false });

    if (error) throw new Error(error.message);

    return { success: true, data };
  }
}
