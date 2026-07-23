import { Injectable, Inject, NotFoundException, ConflictException } from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import { DiyQueryDto } from './dto/diy.dto';

@Injectable()
export class DiyService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async getProjects(query: DiyQueryDto) {
    const { category, difficulty, search, page = '1', limit = '20' } = query;
    const pageNum = Number(page);
    const limitNum = Number(limit);
    const offset = (pageNum - 1) * limitNum;

    let qb = this.supabase
      .from('diy_projects')
      .select('*', { count: 'exact' })
      .order('created_at', { ascending: false })
      .range(offset, offset + limitNum - 1);

    if (category) {
      qb = qb.eq('category', category);
    }
    if (difficulty) {
      qb = qb.eq('difficulty', difficulty);
    }
    if (search) {
      qb = qb.or(`title.ilike.%${search}%,description.ilike.%${search}%`);
    }

    const { data, error, count } = await qb;

    if (error) throw new Error(error.message);

    return {
      success: true,
      data,
      pagination: {
        page: pageNum,
        limit: limitNum,
        total: count || 0,
        total_pages: Math.ceil((count || 0) / limitNum),
      },
    };
  }

  async getProjectById(id: string) {
    const { data, error } = await this.supabase
      .from('diy_projects')
      .select('*')
      .eq('id', id)
      .single();

    if (error || !data) throw new NotFoundException('Project not found');

    return { success: true, data };
  }

  async saveProject(userId: string, projectId: string) {
    // Check project exists
    const { data: project } = await this.supabase
      .from('diy_projects')
      .select('id')
      .eq('id', projectId)
      .single();

    if (!project) throw new NotFoundException('Project not found');

    // Check if already saved
    const { data: existing } = await this.supabase
      .from('diy_saved')
      .select('id')
      .eq('user_id', userId)
      .eq('project_id', projectId)
      .single();

    if (existing) throw new ConflictException('Project already saved');

    const { error } = await this.supabase
      .from('diy_saved')
      .insert({ user_id: userId, project_id: projectId });

    if (error) throw new Error(error.message);

    return { success: true, message: 'Project saved' };
  }

  async unsaveProject(userId: string, projectId: string) {
    const { error } = await this.supabase
      .from('diy_saved')
      .delete()
      .eq('user_id', userId)
      .eq('project_id', projectId);

    if (error) throw new Error(error.message);

    return { success: true, message: 'Project unsaved' };
  }

  async getSavedProjects(userId: string) {
    const { data, error } = await this.supabase
      .from('diy_saved')
      .select('id, created_at, diy_projects(*)')
      .eq('user_id', userId)
      .order('created_at', { ascending: false });

    if (error) throw new Error(error.message);

    return {
      success: true,
      data: data.map((s) => ({
        saved_id: s.id,
        saved_at: s.created_at,
        project: s.diy_projects,
      })),
    };
  }
}
