import {
  Injectable,
  Inject,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import {
  CreatePostDto,
  CreateCommentDto,
  CreateReportDto,
  ResolveReportDto,
} from './dto/community.dto';

@Injectable()
export class CommunityService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
  ) {}

  async createPost(authorId: string, dto: CreatePostDto) {
    const { image_urls, ...postData } = dto;

    const { data: post, error } = await this.supabase
      .from('posts')
      .insert({ ...postData, author_id: authorId })
      .select()
      .single();

    if (error) throw new Error(error.message);

    if (image_urls && image_urls.length > 0) {
      const images = image_urls.map((url) => ({
        post_id: post.id,
        image_url: url,
      }));

      const { error: imgError } = await this.supabase
        .from('post_images')
        .insert(images);

      if (imgError) throw new Error(imgError.message);
    }

    return { success: true, data: post };
  }

  async getFeed(params: { type?: string; page?: number; limit?: number }) {
    const { type, page = 1, limit = 20 } = params;
    const offset = (page - 1) * limit;

    let query = this.supabase
      .from('posts')
      .select(
        `
        *,
        users:author_id(id, full_name, profile_photo),
        post_images(image_url),
        post_likes(user_id)
      `,
        { count: 'exact' },
      )
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (type) {
      query = query.eq('post_type', type);
    }

    const { data, error, count } = await query;

    if (error) throw new Error(error.message);

    return {
      success: true,
      data,
      pagination: {
        page,
        limit,
        total: count || 0,
        total_pages: Math.ceil((count || 0) / limit),
      },
    };
  }

  async getPostById(id: string) {
    const { data, error } = await this.supabase
      .from('posts')
      .select(
        `
        *,
        users:author_id(id, full_name, profile_photo),
        post_images(image_url),
        post_comments(*, users:author_id(id, full_name, profile_photo))
      `,
      )
      .eq('id', id)
      .single();

    if (error || !data) throw new NotFoundException('Post not found');

    return { success: true, data };
  }

  async likePost(userId: string, postId: string) {
    const { data: existing } = await this.supabase
      .from('post_likes')
      .select('id')
      .eq('post_id', postId)
      .eq('user_id', userId)
      .single();

    if (existing) {
      await this.supabase.from('post_likes').delete().eq('id', existing.id);

      await this.supabase.rpc('decrement_column', {
        table_name: 'posts',
        column_name: 'likes_count',
        row_id: postId,
      });

      return { success: true, liked: false };
    }

    const { error } = await this.supabase
      .from('post_likes')
      .insert({ post_id: postId, user_id: userId });

    if (error) throw new Error(error.message);

    await this.supabase.rpc('increment_column', {
      table_name: 'posts',
      column_name: 'likes_count',
      row_id: postId,
    });

    return { success: true, liked: true };
  }

  async addComment(authorId: string, postId: string, dto: CreateCommentDto) {
    const { data: comment, error } = await this.supabase
      .from('post_comments')
      .insert({
        post_id: postId,
        author_id: authorId,
        content: dto.content,
      })
      .select()
      .single();

    if (error) throw new Error(error.message);

    await this.supabase.rpc('increment_column', {
      table_name: 'posts',
      column_name: 'comments_count',
      row_id: postId,
    });

    return { success: true, data: comment };
  }

  async deletePost(id: string, authorId: string) {
    const { data: existing } = await this.supabase
      .from('posts')
      .select('author_id')
      .eq('id', id)
      .single();

    if (!existing) throw new NotFoundException('Post not found');
    if (existing.author_id !== authorId)
      throw new ForbiddenException('Not your post');

    const { error } = await this.supabase.from('posts').delete().eq('id', id);

    if (error) throw new Error(error.message);

    return { success: true, message: 'Post deleted' };
  }

  async createReport(reporterId: string, dto: CreateReportDto) {
    const { data: report, error } = await this.supabase
      .from('reports')
      .insert({
        reporter_id: reporterId,
        content_type: dto.content_type,
        content_id: dto.content_id,
        reason: dto.reason,
        description: dto.description,
      })
      .select()
      .single();

    if (error) throw new Error(error.message);

    return { success: true, data: report };
  }

  async getReports(params: { status?: string; page?: number; limit?: number }) {
    const { status, page = 1, limit = 20 } = params;
    const offset = (page - 1) * limit;

    let query = this.supabase
      .from('reports')
      .select('*, users:reporter_id(id, full_name)', { count: 'exact' })
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (status) {
      query = query.eq('status', status);
    }

    const { data, error, count } = await query;

    if (error) throw new Error(error.message);

    return {
      success: true,
      data,
      pagination: {
        page,
        limit,
        total: count || 0,
        total_pages: Math.ceil((count || 0) / limit),
      },
    };
  }

  async resolveReport(id: string, adminId: string, dto: ResolveReportDto) {
    const { data: existing } = await this.supabase
      .from('reports')
      .select('id')
      .eq('id', id)
      .single();

    if (!existing) throw new NotFoundException('Report not found');

    const { data, error } = await this.supabase
      .from('reports')
      .update({
        status: dto.status,
        admin_id: adminId,
        action_taken: dto.action_taken,
      })
      .eq('id', id)
      .select()
      .single();

    if (error) throw new Error(error.message);

    return { success: true, data };
  }
}
