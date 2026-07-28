import { Injectable, Inject, NotFoundException, ConflictException, ForbiddenException } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import { AppCacheService } from '../../common/cache/cache.service';
import { ensureUserExists } from '../../common/helpers/user-sync.helper';
import { CreateCampusDto, UpdateCampusDto } from './dto/campus.dto';

const CAMPUS_LIST_CACHE_KEY = 'campus:list:active';

function campusSlugCacheKey(slug: string): string {
  return `campus:slug:${slug}`;
}

@Injectable()
export class CampusesService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
    private readonly cacheService: AppCacheService,
  ) {}

  async getAllActive() {
    try {
      const cached = await this.cacheService.get<any>(CAMPUS_LIST_CACHE_KEY);
      if (cached) return { success: true, data: cached };

      const { data, error } = await this.supabase
        .from('campuses')
        .select('*')
        .eq('is_active', true)
        .order('name', { ascending: true });

      if (error) throw new Error(error.message);

      await this.cacheService.set(CAMPUS_LIST_CACHE_KEY, data || []);
      return { success: true, data: data || [] };
    } catch (_) {
      return { success: true, data: [] };
    }
  }

  async getBySlug(slug: string) {
    try {
      const cacheKey = campusSlugCacheKey(slug);
      const cached = await this.cacheService.get<any>(cacheKey);
      if (cached) return { success: true, data: cached };

      const { data, error } = await this.supabase
        .from('campuses')
        .select('*')
        .eq('slug', slug)
        .single();

      if (error || !data) throw new NotFoundException('Campus not found');

      await this.cacheService.set(cacheKey, data);
      return { success: true, data };
    } catch (e: any) {
      if (e instanceof NotFoundException) throw e;
      return { success: false, error: 'Campus not found' };
    }
  }

  async getById(id: string) {
    try {
      const { data, error } = await this.supabase
        .from('campuses')
        .select('*')
        .eq('id', id)
        .single();

      if (error || !data) throw new NotFoundException('Campus not found');

      return { success: true, data };
    } catch (e: any) {
      if (e instanceof NotFoundException) throw e;
      return { success: false, error: 'Campus not found' };
    }
  }

  async create(dto: CreateCampusDto) {
    const slug = dto.name
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/^-+|-+$/g, '');

    try {
      const { data, error } = await this.supabase
        .from('campuses')
        .insert({
          slug,
          name: dto.name,
          short_name: dto.short_name || null,
          domain: dto.domain || null,
          logo_url: dto.logo_url || null,
          city: dto.city || null,
          state: dto.state || null,
          country: dto.country || 'IN',
        })
        .select()
        .single();

      if (error) {
        if (error.code === '23505') {
          throw new ConflictException('A campus with this slug or domain already exists');
        }
        throw new Error(error.message);
      }

      await this.cacheService.del(CAMPUS_LIST_CACHE_KEY);
      return { success: true, data };
    } catch (e: any) {
      if (e instanceof ConflictException) throw e;
      return { success: false, error: e.message || 'Failed to create campus' };
    }
  }

  async updateBySlug(slug: string, dto: UpdateCampusDto) {
    try {
      const updateData: Record<string, any> = {};
      if (dto.name !== undefined) updateData.name = dto.name;
      if (dto.short_name !== undefined) updateData.short_name = dto.short_name;
      if (dto.domain !== undefined) updateData.domain = dto.domain;
      if (dto.logo_url !== undefined) updateData.logo_url = dto.logo_url;
      if (dto.city !== undefined) updateData.city = dto.city;
      if (dto.state !== undefined) updateData.state = dto.state;
      if (dto.country !== undefined) updateData.country = dto.country;
      if (dto.settings !== undefined) updateData.settings = dto.settings;

      if (Object.keys(updateData).length === 0) {
        return { success: false, error: 'No fields to update' };
      }

      const { data, error } = await this.supabase
        .from('campuses')
        .update(updateData)
        .eq('slug', slug)
        .select()
        .single();

      if (error) throw new Error(error.message);
      if (!data) throw new NotFoundException('Campus not found');

      await this.cacheService.del(CAMPUS_LIST_CACHE_KEY);
      await this.cacheService.del(campusSlugCacheKey(slug));
      return { success: true, data };
    } catch (e: any) {
      if (e instanceof NotFoundException) throw e;
      return { success: false, error: e.message || 'Failed to update campus' };
    }
  }

  async deactivateBySlug(slug: string) {
    try {
      const { data, error } = await this.supabase
        .from('campuses')
        .update({ is_active: false })
        .eq('slug', slug)
        .select()
        .single();

      if (error) throw new Error(error.message);
      if (!data) throw new NotFoundException('Campus not found');

      await this.cacheService.del(CAMPUS_LIST_CACHE_KEY);
      await this.cacheService.del(campusSlugCacheKey(slug));
      return { success: true, data };
    } catch (e: any) {
      if (e instanceof NotFoundException) throw e;
      return { success: false, error: e.message || 'Failed to deactivate campus' };
    }
  }

  async setUserCampus(userId: string, campusSlug: string) {
    await ensureUserExists(this.supabase, userId);

    try {
      const campusRes = await this.getBySlug(campusSlug);
      if (!campusRes.success || !campusRes.data) {
        return { success: false, error: 'Campus not found' };
      }

      const campus = campusRes.data;
      if (!campus.is_active) {
        return { success: false, error: 'Campus is not active' };
      }

      const campusId = campus.id;

      const { data: user } = await this.supabase
        .from('users')
        .select('campus_id')
        .eq('id', userId)
        .single();

      if (user && user.campus_id === campusId) {
        return { success: true, data: { campus_id: campusId, unchanged: true } };
      }

      const { data, error } = await this.supabase
        .from('users')
        .update({
          campus_id: campusId,
          campus_joined_at: new Date().toISOString(),
        })
        .eq('id', userId)
        .select()
        .single();

      if (error) throw new Error(error.message);

      return { success: true, data };
    } catch (e: any) {
      return { success: false, error: e.message || 'Failed to set campus' };
    }
  }
}
