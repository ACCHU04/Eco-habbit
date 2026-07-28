import { Test, TestingModule } from '@nestjs/testing';
import { AdminService } from './admin.service';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { AppCacheService } from '../../common/cache/cache.service';

describe('AdminService', () => {
  let service: AdminService;
  let s: any;
  let cache: any;

  beforeEach(async () => {
    s = {
      from: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      insert: jest.fn().mockReturnThis(),
      update: jest.fn().mockReturnThis(),
      delete: jest.fn().mockReturnThis(),
      eq: jest.fn().mockReturnThis(),
      neq: jest.fn().mockReturnThis(),
      or: jest.fn().mockReturnThis(),
      order: jest.fn().mockReturnThis(),
      range: jest.fn().mockReturnThis(),
      single: jest.fn(),
    };

    cache = {
      get: jest.fn().mockResolvedValue(null),
      set: jest.fn().mockResolvedValue(undefined),
      del: jest.fn().mockResolvedValue(undefined),
      invalidatePattern: jest.fn().mockResolvedValue(undefined),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AdminService,
        { provide: SUPABASE_CLIENT, useValue: s },
        { provide: AppCacheService, useValue: cache },
      ],
    }).compile();

    service = module.get<AdminService>(AdminService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getDashboard', () => {
    it('returns dashboard stats', async () => {
      s.select
        .mockResolvedValueOnce({ data: null, error: null, count: 100 })
        .mockResolvedValueOnce({ data: null, error: null, count: 50 })
        .mockResolvedValueOnce({ data: null, error: null, count: 3 })
        .mockResolvedValueOnce({ data: null, error: null, count: 25 });
      s.from
        .mockReturnValueOnce({ select: jest.fn().mockResolvedValue({ data: null, error: null, count: 100 }) })
        .mockReturnValueOnce({ select: jest.fn().mockResolvedValue({ data: null, error: null, count: 50 }) })
        .mockReturnValueOnce({ select: jest.fn().mockReturnValue({ eq: jest.fn().mockResolvedValue({ data: null, error: null, count: 3 }) }) })
        .mockReturnValueOnce({ select: jest.fn().mockReturnValue({ eq: jest.fn().mockResolvedValue({ data: null, error: null, count: 25 }) }) })
        .mockReturnValueOnce({
          select: jest.fn().mockResolvedValue({
            data: [
              { role: 'student' },
              { role: 'student' },
              { role: 'admin' },
            ],
            error: null,
          }),
        });

      const result = await service.getDashboard();

      expect(result.success).toBe(true);
      expect(result.data).toBeDefined();
      expect(cache.set).toHaveBeenCalled();
    });

    it('returns cached dashboard when available', async () => {
      const cachedData = { success: true, data: { total_users: 100 } };
      cache.get.mockResolvedValue(cachedData);

      const result = await service.getDashboard();

      expect(result).toEqual(cachedData);
    });
  });

  describe('getUsers', () => {
    it('returns paginated users', async () => {
      const users = [{ id: 'u1', full_name: 'Alice', role: 'student' }];
      s.from.mockReturnValue({
        select: jest.fn().mockReturnValue({
          or: jest.fn().mockReturnThis(),
          eq: jest.fn().mockReturnThis(),
          order: jest.fn().mockReturnThis(),
          range: jest.fn().mockResolvedValue({
            data: users,
            error: null,
            count: 1,
          }),
        }),
      });

      const result = await service.getUsers({ page: 1, limit: 20 });

      expect(result.success).toBe(true);
      expect(result.data).toEqual(users);
    });
  });

  describe('changeUserRole', () => {
    it('promotes a student to moderator', async () => {
      s.from
        .mockReturnValueOnce({
          select: jest.fn().mockReturnValue({
            eq: jest.fn().mockReturnValue({
              single: jest.fn()
                .mockResolvedValueOnce({ data: { id: 'u1', role: 'student', status: 'active' }, error: null })
                .mockResolvedValueOnce({ data: { id: 'admin1', role: 'super_admin', status: 'active' }, error: null }),
            }),
          }),
        })
        .mockReturnValueOnce({
          select: jest.fn().mockReturnValue({
            eq: jest.fn().mockReturnValue({
              single: jest.fn().mockResolvedValue({
                data: { id: 'admin1', role: 'super_admin', status: 'active' },
                error: null,
              }),
            }),
          }),
        })
        .mockReturnValueOnce({
          select: jest.fn().mockReturnValue({
            eq: jest.fn().mockReturnValue({
              single: jest.fn().mockResolvedValue({
                data: { id: 'u1', role: 'student', status: 'active' },
                error: null,
              }),
            }),
          }),
        })
        .mockReturnValueOnce({
          update: jest.fn().mockReturnValue({
            eq: jest.fn().mockResolvedValue({ error: null }),
          }),
        })
        .mockReturnValueOnce({
          insert: jest.fn().mockResolvedValue({ error: null }),
        });

      const result = await service.changeUserRole('admin1', 'u1', 'moderator');

      expect(result.success).toBe(true);
      expect(cache.invalidatePattern).toHaveBeenCalled();
    });

    it('prevents non-super_admin from changing admin roles', async () => {
      s.from.mockReturnValue({
        select: jest.fn().mockReturnValue({
          eq: jest.fn().mockReturnValue({
            single: jest.fn()
              .mockResolvedValueOnce({ data: { id: 'u1', role: 'admin', status: 'active' }, error: null })
              .mockResolvedValueOnce({ data: { id: 'admin1', role: 'admin', status: 'active' }, error: null }),
          }),
        }),
      });

      await expect(
        service.changeUserRole('admin1', 'u1', 'moderator'),
      ).rejects.toThrow('cannot modify');
    });
  });

  describe('changeUserStatus', () => {
    it('suspends an active user', async () => {
      const userChain = {
        select: jest.fn().mockReturnValue({
          eq: jest.fn().mockReturnValue({
            single: jest.fn().mockResolvedValue({
              data: { id: 'u1', role: 'student', status: 'active' },
              error: null,
            }),
          }),
        }),
      };
      const updateChain = {
        update: jest.fn().mockReturnValue({
          eq: jest.fn().mockResolvedValue({ error: null }),
        }),
      };
      const auditChain = {
        insert: jest.fn().mockResolvedValue({ error: null }),
      };

      s.from
        .mockReturnValueOnce(userChain)  // getUser (1st call in changeUserStatus)
        .mockReturnValueOnce(userChain)  // getUser (2nd call in validateSuperAdminProtection)
        .mockReturnValueOnce(updateChain) // update
        .mockReturnValueOnce(auditChain); // audit insert

      const result = await service.changeUserStatus('admin1', 'u1', 'suspended');

      expect(result.success).toBe(true);
      expect(result.message).toContain('suspended');
    });

    it('rejects invalid status transition', async () => {
      s.from.mockReturnValue({
        select: jest.fn().mockReturnValue({
          eq: jest.fn().mockReturnValue({
            single: jest.fn().mockResolvedValue({
              data: { id: 'u1', role: 'student', status: 'deactivated' },
              error: null,
            }),
          }),
        }),
      });

      await expect(
        service.changeUserStatus('admin1', 'u1', 'active'),
      ).rejects.toThrow('Cannot transition');
    });

    it('prevents deactivating the last super_admin', async () => {
      const superAdminUser = {
        select: jest.fn().mockReturnValue({
          eq: jest.fn().mockReturnValue({
            single: jest.fn().mockResolvedValue({
              data: { id: 'u1', role: 'super_admin', status: 'active' },
              error: null,
            }),
          }),
        }),
      };
      const countChain = {
        select: jest.fn().mockReturnValue({
          eq: jest.fn().mockReturnThis(),
          neq: jest.fn().mockResolvedValue({ count: 0, error: null }),
        }),
      };

      s.from
        .mockReturnValueOnce(superAdminUser)  // getUser (1st call)
        .mockReturnValueOnce(superAdminUser)  // getUser (2nd call in validateSuperAdminProtection)
        .mockReturnValueOnce(countChain);      // countActiveSuperAdmins

      await expect(
        service.changeUserStatus('admin1', 'u1', 'deactivated'),
      ).rejects.toThrow('last active super_admin');
    });
  });

  describe('resolveReport', () => {
    it('resolves a report successfully', async () => {
      s.from
        .mockReturnValueOnce({
          select: jest.fn().mockReturnValue({
            eq: jest.fn().mockReturnValue({
              single: jest.fn().mockResolvedValue({
                data: { id: 'r1', content_type: 'post', content_id: 'p1' },
                error: null,
              }),
            }),
          }),
        })
        .mockReturnValueOnce({
          update: jest.fn().mockReturnValue({
            eq: jest.fn().mockResolvedValue({ error: null }),
          }),
        })
        .mockReturnValueOnce({
          insert: jest.fn().mockResolvedValue({ error: null }),
        });

      const result = await service.resolveReport('admin1', 'r1', {
        status: 'resolved',
        action_taken: 'Post removed',
      });

      expect(result.success).toBe(true);
    });
  });

  describe('deletePost', () => {
    it('deletes a post and logs audit', async () => {
      s.from
        .mockReturnValueOnce({
          select: jest.fn().mockReturnValue({
            eq: jest.fn().mockReturnValue({
              single: jest.fn().mockResolvedValue({
                data: { id: 'p1', author_id: 'u1', post_type: 'tip' },
                error: null,
              }),
            }),
          }),
        })
        .mockReturnValueOnce({
          delete: jest.fn().mockReturnValue({
            eq: jest.fn().mockResolvedValue({ error: null }),
          }),
        })
        .mockReturnValueOnce({
          insert: jest.fn().mockResolvedValue({ error: null }),
        });

      const result = await service.deletePost('admin1', 'p1', 'Spam content');

      expect(result.success).toBe(true);
      expect(cache.invalidatePattern).toHaveBeenCalled();
    });
  });

  describe('getAuditLog', () => {
    it('returns paginated audit log', async () => {
      const entries = [
        { id: 'a1', action: 'delete_post', resource_type: 'post' },
      ];
      s.from.mockReturnValue({
        select: jest.fn().mockReturnValue({
          eq: jest.fn().mockReturnThis(),
          order: jest.fn().mockReturnThis(),
          range: jest.fn().mockResolvedValue({
            data: entries,
            error: null,
            count: 1,
          }),
        }),
      });

      const result = await service.getAuditLog({ page: 1, limit: 50 });

      expect(result.success).toBe(true);
      expect(result.data).toEqual(entries);
    });
  });
});
