import {
  Injectable,
  Inject,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { SupabaseClient } from '@supabase/supabase-js';
import { AppCacheService, CacheKeys } from '../../common/cache/cache.service';
import {
  ROLE_HIERARCHY,
  hasPermission,
  canManageUser,
  VALID_STATUS_TRANSITIONS,
} from './admin.permissions';

@Injectable()
export class AdminService {
  constructor(
    @Inject(SUPABASE_CLIENT)
    private readonly supabase: SupabaseClient,
    private readonly cacheService: AppCacheService,
  ) {}

  private async logAudit(
    adminId: string,
    action: string,
    resourceType: string,
    resourceId: string,
    reason?: string,
    metadata?: Record<string, unknown>,
  ): Promise<void> {
    await this.supabase.from('admin_audit_log').insert({
      admin_id: adminId,
      action,
      resource_type: resourceType,
      resource_id: resourceId,
      reason: reason ?? null,
      metadata: metadata ?? {},
    });
  }

  private async getUser(userId: string) {
    const { data, error } = await this.supabase
      .from('users')
      .select('*')
      .eq('id', userId)
      .single();

    if (error || !data) {
      throw new NotFoundException(`User ${userId} not found`);
    }

    return data;
  }

  private async countActiveSuperAdmins(excludeUserId?: string): Promise<number> {
    let query = this.supabase
      .from('users')
      .select('*', { count: 'exact', head: true })
      .eq('role', 'super_admin')
      .eq('status', 'active');

    if (excludeUserId) {
      query = query.neq('id', excludeUserId);
    }

    const { count, error } = await query;
    if (error) return 0;
    return count ?? 0;
  }

  private async validateSuperAdminProtection(
    targetUserId: string,
    newRole?: string,
    newStatus?: string,
  ): Promise<void> {
    const target = await this.getUser(targetUserId);
    const isCurrentlySuperAdmin = target.role === 'super_admin';

    if (!isCurrentlySuperAdmin) return;

    const wouldLoseSuperAdminStatus = isCurrentlySuperAdmin && (
      (newRole !== undefined && newRole !== 'super_admin') ||
      (newStatus !== undefined && newStatus !== 'active')
    );

    if (wouldLoseSuperAdminStatus) {
      const remaining = await this.countActiveSuperAdmins(targetUserId);
      if (remaining === 0) {
        throw new BadRequestException(
          'Cannot modify the last active super_admin. Promote another user first.',
        );
      }
    }
  }

  async getDashboard() {
    const cacheKey = 'admin:dashboard';
    const cached = await this.cacheService.get<any>(cacheKey);
    if (cached) return cached;

    const [usersResult, postsResult, reportsResult, listingsResult] =
      await Promise.all([
        this.supabase
          .from('users')
          .select('*', { count: 'exact', head: true }),
        this.supabase
          .from('posts')
          .select('*', { count: 'exact', head: true }),
        this.supabase
          .from('reports')
          .select('*', { count: 'exact', head: true })
          .eq('status', 'pending'),
        this.supabase
          .from('marketplace_listings')
          .select('*', { count: 'exact', head: true })
          .eq('status', 'active'),
      ]);

    const roleBreakdown = await this.supabase
      .from('users')
      .select('role')
      .then(({ data }) => {
        const counts: Record<string, number> = {};
        data?.forEach((u) => {
          counts[u.role] = (counts[u.role] || 0) + 1;
        });
        return counts;
      });

    const result = {
      success: true,
      data: {
        total_users: usersResult.count ?? 0,
        total_posts: postsResult.count ?? 0,
        pending_reports: reportsResult.count ?? 0,
        active_listings: listingsResult.count ?? 0,
        role_breakdown: roleBreakdown,
      },
    };

    await this.cacheService.set(cacheKey, result, 30_000);
    return result;
  }

  async getUsers(query: {
    search?: string;
    role?: string;
    status?: string;
    page?: number;
    limit?: number;
  }) {
    const { search, role, status, page = 1, limit = 20 } = query;
    const offset = (page - 1) * limit;

    let dbQuery = this.supabase
      .from('users')
      .select(
        'id, email, full_name, college, role, status, profile_photo, created_at, hostel, department',
        { count: 'exact' },
      );

    if (search) {
      dbQuery = dbQuery.or(
        `full_name.ilike.%${search}%,email.ilike.%${search}%`,
      );
    }
    if (role) dbQuery = dbQuery.eq('role', role);
    if (status) dbQuery = dbQuery.eq('status', status);

    dbQuery = dbQuery.order('created_at', { ascending: false });
    dbQuery = dbQuery.range(offset, offset + limit - 1);

    const { data, error, count } = await dbQuery;
    if (error) throw new Error(error.message);

    return {
      success: true,
      data: data || [],
      pagination: {
        page,
        limit,
        total: count ?? 0,
        total_pages: Math.ceil((count ?? 0) / limit),
      },
    };
  }

  async getUserDetail(userId: string) {
    const user = await this.getUser(userId);

    const { data: stats } = await this.supabase
      .from('eco_rewards')
      .select('points')
      .eq('user_id', userId);

    const total_points =
      stats?.reduce((sum, r) => sum + (r.points ?? 0), 0) ?? 0;

    const { count: postCount } = await this.supabase
      .from('posts')
      .select('*', { count: 'exact', head: true })
      .eq('author_id', userId);

    const { count: listingCount } = await this.supabase
      .from('marketplace_listings')
      .select('*', { count: 'exact', head: true })
      .eq('seller_id', userId);

    return {
      success: true,
      data: {
        ...user,
        stats: {
          total_points: total_points,
          posts_count: postCount ?? 0,
          listings_count: listingCount ?? 0,
        },
      },
    };
  }

  async changeUserRole(
    adminId: string,
    targetUserId: string,
    newRole: string,
    reason?: string,
  ) {
    const target = await this.getUser(targetUserId);
    const admin = await this.getUser(adminId);

    if (!canManageUser(admin.role, target.role)) {
      throw new BadRequestException(
        `Your role (${admin.role}) cannot modify a user with role (${target.role})`,
      );
    }

    if (!canManageUser(admin.role, newRole)) {
      throw new BadRequestException(
        `Your role (${admin.role}) cannot assign role (${newRole})`,
      );
    }

    await this.validateSuperAdminProtection(targetUserId, newRole);

    const { error } = await this.supabase
      .from('users')
      .update({ role: newRole })
      .eq('id', targetUserId);

    if (error) throw new Error(error.message);

    await this.logAudit(
      adminId,
      'change_role',
      'user',
      targetUserId,
      reason,
      { from: target.role, to: newRole },
    );

    await this.cacheService.invalidatePattern('admin:');

    return {
      success: true,
      message: `User role changed from ${target.role} to ${newRole}`,
    };
  }

  async changeUserStatus(
    adminId: string,
    targetUserId: string,
    newStatus: string,
    reason?: string,
  ) {
    const target = await this.getUser(targetUserId);

    const allowed = VALID_STATUS_TRANSITIONS[target.status] ?? [];
    if (!allowed.includes(newStatus)) {
      throw new BadRequestException(
        `Cannot transition from '${target.status}' to '${newStatus}'`,
      );
    }

    await this.validateSuperAdminProtection(targetUserId, undefined, newStatus);

    const { error } = await this.supabase
      .from('users')
      .update({ status: newStatus })
      .eq('id', targetUserId);

    if (error) throw new Error(error.message);

    await this.logAudit(
      adminId,
      'change_status',
      'user',
      targetUserId,
      reason,
      { from: target.status, to: newStatus },
    );

    await this.cacheService.invalidatePattern('admin:');

    return {
      success: true,
      message: `User status changed from ${target.status} to ${newStatus}`,
    };
  }

  async getReports(query: {
    status?: string;
    page?: number;
    limit?: number;
  }) {
    const { status, page = 1, limit = 20 } = query;
    const offset = (page - 1) * limit;

    let dbQuery = this.supabase
      .from('reports')
      .select(
        '*, reporter:users!reports_reporter_id_fkey(full_name, profile_photo)',
        { count: 'exact' },
      );

    if (status) dbQuery = dbQuery.eq('status', status);

    dbQuery = dbQuery.order('created_at', { ascending: false });
    dbQuery = dbQuery.range(offset, offset + limit - 1);

    const { data, error, count } = await dbQuery;
    if (error) throw new Error(error.message);

    return {
      success: true,
      data: data || [],
      pagination: {
        page,
        limit,
        total: count ?? 0,
        total_pages: Math.ceil((count ?? 0) / limit),
      },
    };
  }

  async resolveReport(
    adminId: string,
    reportId: string,
    dto: { status: 'resolved' | 'dismissed'; action_taken?: string; reason?: string },
  ) {
    const { data: report, error: fetchError } = await this.supabase
      .from('reports')
      .select('*')
      .eq('id', reportId)
      .single();

    if (fetchError || !report) {
      throw new NotFoundException(`Report ${reportId} not found`);
    }

    const { error } = await this.supabase
      .from('reports')
      .update({
        status: dto.status,
        admin_id: adminId,
        action_taken: dto.action_taken ?? null,
      })
      .eq('id', reportId);

    if (error) throw new Error(error.message);

    await this.logAudit(
      adminId,
      `resolve_report_${dto.status}`,
      'report',
      reportId,
      dto.reason,
      {
        content_type: report.content_type,
        content_id: report.content_id,
        action_taken: dto.action_taken,
      },
    );

    await this.cacheService.invalidatePattern('admin:');

    return {
      success: true,
      message: `Report ${dto.status}`,
    };
  }

  async deletePost(adminId: string, postId: string, reason?: string) {
    const { data: post, error: fetchError } = await this.supabase
      .from('posts')
      .select('*')
      .eq('id', postId)
      .single();

    if (fetchError || !post) {
      throw new NotFoundException(`Post ${postId} not found`);
    }

    const { error } = await this.supabase
      .from('posts')
      .delete()
      .eq('id', postId);

    if (error) throw new Error(error.message);

    await this.logAudit(adminId, 'delete_post', 'post', postId, reason, {
      author_id: post.author_id,
      post_type: post.post_type,
    });

    await this.cacheService.invalidatePattern('community:');
    await this.cacheService.invalidatePattern('admin:');

    return { success: true, message: 'Post deleted' };
  }

  async deleteListing(adminId: string, listingId: string, reason?: string) {
    const { data: listing, error: fetchError } = await this.supabase
      .from('marketplace_listings')
      .select('*')
      .eq('id', listingId)
      .single();

    if (fetchError || !listing) {
      throw new NotFoundException(`Listing ${listingId} not found`);
    }

    const { error } = await this.supabase
      .from('marketplace_listings')
      .delete()
      .eq('id', listingId);

    if (error) throw new Error(error.message);

    await this.logAudit(adminId, 'delete_listing', 'listing', listingId, reason, {
      seller_id: listing.seller_id,
      title: listing.title,
    });

    await this.cacheService.invalidatePattern('admin:');

    return { success: true, message: 'Listing deleted' };
  }

  async getAuditLog(query: {
    admin_id?: string;
    action?: string;
    resource_type?: string;
    page?: number;
    limit?: number;
  }) {
    const { admin_id, action, resource_type, page = 1, limit = 50 } = query;
    const offset = (page - 1) * limit;

    let dbQuery = this.supabase
      .from('admin_audit_log')
      .select(
        '*, admin:users!admin_audit_log_admin_id_fkey(full_name, email)',
        { count: 'exact' },
      );

    if (admin_id) dbQuery = dbQuery.eq('admin_id', admin_id);
    if (action) dbQuery = dbQuery.eq('action', action);
    if (resource_type) dbQuery = dbQuery.eq('resource_type', resource_type);

    dbQuery = dbQuery.order('created_at', { ascending: false });
    dbQuery = dbQuery.range(offset, offset + limit - 1);

    const { data, error, count } = await dbQuery;
    if (error) throw new Error(error.message);

    return {
      success: true,
      data: data || [],
      pagination: {
        page,
        limit,
        total: count ?? 0,
        total_pages: Math.ceil((count ?? 0) / limit),
      },
    };
  }
}
