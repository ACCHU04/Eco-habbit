import {
  Injectable,
  Inject,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import { randomUUID } from 'crypto';
import { ensureUserExists } from '../../common/helpers/user-sync.helper';
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
    await ensureUserExists(this.supabase, authorId);
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
      data: data || [],
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
    await ensureUserExists(this.supabase, userId);
    const { data: existing } = await this.supabase
      .from('post_likes')
      .select('id')
      .eq('post_id', postId)
      .eq('user_id', userId)
      .single();

    if (existing) {
      await this.supabase.from('post_likes').delete().eq('id', existing.id);

      await this.supabase.rpc('decrement_column', {
        p_table_name: 'posts',
        p_column_name: 'likes_count',
        p_row_id: postId,
      });

      return { success: true, liked: false };
    }

    const { error } = await this.supabase
      .from('post_likes')
      .insert({ post_id: postId, user_id: userId });

    if (error) throw new Error(error.message);

    await this.supabase.rpc('increment_column', {
      p_table_name: 'posts',
      p_column_name: 'likes_count',
      p_row_id: postId,
    });

    const { data: post } = await this.supabase
      .from('posts')
      .select('author_id')
      .eq('id', postId)
      .single();

    if (post && post.author_id !== userId) {
      const { data: liker } = await this.supabase
        .from('users')
        .select('full_name')
        .eq('id', userId)
        .single();

      await this.createNotification(
        post.author_id,
        'like',
        'New like',
        `${liker?.full_name ?? 'Someone'} liked your post`,
        { post_id: postId },
      );
    }

    return { success: true, liked: true };
  }

  async addComment(authorId: string, postId: string, dto: CreateCommentDto) {
    await ensureUserExists(this.supabase, authorId);
    const { data: post } = await this.supabase
      .from('posts')
      .select('author_id')
      .eq('id', postId)
      .single();

    const { data: commenter } = await this.supabase
      .from('users')
      .select('full_name')
      .eq('id', authorId)
      .single();

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
      p_table_name: 'posts',
      p_column_name: 'comments_count',
      p_row_id: postId,
    });

    if (post && post.author_id !== authorId) {
      await this.createNotification(
        post.author_id,
        'comment',
        'New comment',
        `${commenter?.full_name ?? 'Someone'} commented on your post`,
        { post_id: postId, comment_id: comment.id },
      );
    }

    return { success: true, data: comment };
  }

  private async createNotification(
    userId: string,
    type: string,
    title: string,
    body: string,
    data?: Record<string, any>,
  ) {
    try {
      await this.supabase.from('notifications').insert({
        user_id: userId,
        type,
        title,
        body,
        data: data || null,
      });
    } catch (_) {
      // Best-effort — don't fail the request
    }
  }

  async deleteComment(commentId: string, postId: string, userId: string) {
    const { data: comment } = await this.supabase
      .from('post_comments')
      .select('id, author_id')
      .eq('id', commentId)
      .eq('post_id', postId)
      .single();

    if (!comment) throw new NotFoundException('Comment not found');

    const { data: post } = await this.supabase
      .from('posts')
      .select('author_id')
      .eq('id', postId)
      .single();

    if (comment.author_id !== userId && (!post || post.author_id !== userId)) {
      throw new ForbiddenException('Not authorized to delete this comment');
    }

    const { error } = await this.supabase
      .from('post_comments')
      .delete()
      .eq('id', commentId);

    if (error) throw new Error(error.message);

    await this.supabase.rpc('decrement_column', {
      p_table_name: 'posts',
      p_column_name: 'comments_count',
      p_row_id: postId,
    });

    return { success: true, message: 'Comment deleted' };
  }

  async searchPosts(params: { q: string; type?: string; page?: number; limit?: number }) {
    const { q, type, page = 1, limit = 20 } = params;
    if (!q || q.trim().length < 2) {
      throw new BadRequestException('Search query must be at least 2 characters');
    }
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
      .ilike('content', `%${q.trim()}%`)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (type) {
      query = query.eq('post_type', type);
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
  }

  async getTrending(params: { limit?: number }) {
    const { limit = 10 } = params;

    const { data, error } = await this.supabase
      .rpc('get_trending_posts', { result_limit: limit });

    if (error) {
      const fallback = await this.supabase
        .from('posts')
        .select(
          `
          *,
          users:author_id(id, full_name, profile_photo),
          post_images(image_url),
          post_likes(user_id)
        `,
        )
        .order('likes_count', { ascending: false })
        .limit(limit);

      if (fallback.error) throw new Error(fallback.error.message);

      return {
        success: true,
        data: fallback.data || [],
      };
    }

    return {
      success: true,
      data: data || [],
    };
  }

  async toggleBookmark(userId: string, postId: string) {
    await ensureUserExists(this.supabase, userId);
    const { data: existing } = await this.supabase
      .from('user_bookmarks')
      .select('id')
      .eq('user_id', userId)
      .eq('post_id', postId)
      .single();

    if (existing) {
      await this.supabase.from('user_bookmarks').delete().eq('id', existing.id);
      return { success: true, bookmarked: false };
    }

    const { error } = await this.supabase
      .from('user_bookmarks')
      .insert({ user_id: userId, post_id: postId });

    if (error) throw new Error(error.message);

    return { success: true, bookmarked: true };
  }

  async getBookmarks(userId: string, page = 1, limit = 20) {
    const offset = (page - 1) * limit;

    const { data, error, count } = await this.supabase
      .from('user_bookmarks')
      .select(
        `
        *,
        post:post_id(
          *,
          users:author_id(id, full_name, profile_photo),
          post_images(image_url),
          post_likes(user_id)
        )
      `,
        { count: 'exact' },
      )
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) throw new Error(error.message);

    return {
      success: true,
      data: (data || []).map((b) => b.post).filter(Boolean),
      pagination: {
        page,
        limit,
        total: count || 0,
        total_pages: Math.ceil((count || 0) / limit),
      },
    };
  }

  async uploadImage(userId: string, file: Express.Multer.File) {
    if (!file) throw new BadRequestException('No file provided');

    const allowedTypes = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
    if (!allowedTypes.includes(file.mimetype)) {
      throw new BadRequestException('Only JPEG, PNG, WebP, and GIF images are allowed');
    }

    const maxSize = 5 * 1024 * 1024;
    if (file.size > maxSize) {
      throw new BadRequestException('Image must be smaller than 5MB');
    }

    const ext = file.originalname.split('.').pop() || 'jpg';
    const path = `${userId}/${randomUUID()}.${ext}`;

    const { error } = await this.supabase.storage
      .from('community-images')
      .upload(path, file.buffer, {
        contentType: file.mimetype,
        upsert: false,
      });

    if (error) throw new Error(error.message);

    const { data: urlData } = this.supabase.storage
      .from('community-images')
      .getPublicUrl(path);

    return { success: true, url: urlData.publicUrl };
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
    await ensureUserExists(this.supabase, reporterId);
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
