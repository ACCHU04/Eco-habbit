import { Test, TestingModule } from '@nestjs/testing';
import { CampusesService } from './campuses.service';
import { AppCacheService } from '../../common/cache/cache.service';

const mockSupabase = {
  from: jest.fn().mockReturnThis(),
  select: jest.fn().mockReturnThis(),
  insert: jest.fn().mockReturnThis(),
  update: jest.fn().mockReturnThis(),
  eq: jest.fn().mockReturnThis(),
  order: jest.fn().mockReturnThis(),
  single: jest.fn(),
};

const mockCache = {
  get: jest.fn(),
  set: jest.fn(),
  del: jest.fn(),
};

describe('CampusesService', () => {
  let service: CampusesService;

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CampusesService,
        { provide: 'SUPABASE_CLIENT', useValue: mockSupabase },
        { provide: AppCacheService, useValue: mockCache },
      ],
    }).compile();

    service = module.get<CampusesService>(CampusesService);
  });

  describe('getAllActive', () => {
    it('returns cached data when available', async () => {
      const cached = [{ id: '1', name: 'Test University' }];
      mockCache.get.mockResolvedValue(cached);

      const result = await service.getAllActive();

      expect(result).toEqual({ success: true, data: cached });
      expect(mockSupabase.from).not.toHaveBeenCalled();
    });

    it('fetches and caches from supabase when cache is empty', async () => {
      const data = [{ id: '1', name: 'Test University', is_active: true }];
      mockCache.get.mockResolvedValue(undefined);
      mockSupabase.from.mockReturnThis();
      mockSupabase.select.mockReturnThis();
      mockSupabase.eq.mockReturnThis();
      mockSupabase.order.mockResolvedValue({ data, error: null });

      const result = await service.getAllActive();

      expect(result).toEqual({ success: true, data });
      expect(mockCache.set).toHaveBeenCalledWith('campus:list:active', data);
    });

    it('returns empty array on error', async () => {
      mockCache.get.mockRejectedValue(new Error('cache down'));

      const result = await service.getAllActive();

      expect(result).toEqual({ success: true, data: [] });
    });
  });

  describe('getBySlug', () => {
    it('returns cached campus by slug', async () => {
      const cached = { id: '1', slug: 'test-uni', name: 'Test University' };
      mockCache.get.mockResolvedValue(cached);

      const result = await service.getBySlug('test-uni');

      expect(result).toEqual({ success: true, data: cached });
    });

    it('fetches and caches from supabase when not cached', async () => {
      const data = { id: '1', slug: 'test-uni', name: 'Test University' };
      mockCache.get.mockResolvedValue(undefined);
      mockSupabase.from.mockReturnThis();
      mockSupabase.select.mockReturnThis();
      mockSupabase.eq.mockReturnThis();
      mockSupabase.single.mockResolvedValue({ data, error: null });

      const result = await service.getBySlug('test-uni');

      expect(result).toEqual({ success: true, data });
      expect(mockCache.set).toHaveBeenCalledWith('campus:slug:test-uni', data);
    });

    it('returns error when campus not found', async () => {
      mockCache.get.mockResolvedValue(undefined);
      mockSupabase.from.mockReturnThis();
      mockSupabase.select.mockReturnThis();
      mockSupabase.eq.mockReturnThis();
      mockSupabase.single.mockResolvedValue({ data: null, error: { message: 'Not found' } });

      await expect(service.getBySlug('nonexistent')).rejects.toThrow();
    });
  });

  describe('getById', () => {
    it('returns campus by id', async () => {
      const data = { id: 'abc-123', name: 'Test University' };
      mockSupabase.from.mockReturnThis();
      mockSupabase.select.mockReturnThis();
      mockSupabase.eq.mockReturnThis();
      mockSupabase.single.mockResolvedValue({ data, error: null });

      const result = await service.getById('abc-123');

      expect(result).toEqual({ success: true, data });
    });

    it('returns error when not found', async () => {
      mockSupabase.from.mockReturnThis();
      mockSupabase.select.mockReturnThis();
      mockSupabase.eq.mockReturnThis();
      mockSupabase.single.mockResolvedValue({ data: null, error: { message: 'Not found' } });

      await expect(service.getById('nonexistent')).rejects.toThrow();
    });
  });

  describe('create', () => {
    it('creates a campus and generates slug', async () => {
      const dto = { name: 'New University', city: 'Mumbai' };
      const inserted = { id: '1', slug: 'new-university', ...dto };
      mockSupabase.from.mockReturnThis();
      mockSupabase.insert.mockReturnThis();
      mockSupabase.select.mockReturnThis();
      mockSupabase.single.mockResolvedValue({ data: inserted, error: null });

      const result = await service.create(dto as any);

      expect(result).toEqual({ success: true, data: inserted });
      expect(mockSupabase.insert).toHaveBeenCalledWith(
        expect.objectContaining({ slug: 'new-university', name: 'New University' }),
      );
      expect(mockCache.del).toHaveBeenCalledWith('campus:list:active');
    });

    it('handles duplicate slug error', async () => {
      const dto = { name: 'New University' };
      mockSupabase.from.mockReturnThis();
      mockSupabase.insert.mockReturnThis();
      mockSupabase.select.mockReturnThis();
      mockSupabase.single.mockResolvedValue({
        data: null,
        error: { code: '23505', message: 'duplicate key' },
      });

      await expect(service.create(dto as any)).rejects.toThrow();
    });
  });

  describe('updateBySlug', () => {
    it('updates campus fields', async () => {
      const updated = { id: '1', slug: 'test-uni', name: 'Updated Name' };
      mockSupabase.from.mockReturnThis();
      mockSupabase.update.mockReturnThis();
      mockSupabase.eq.mockReturnThis();
      mockSupabase.select.mockReturnThis();
      mockSupabase.single.mockResolvedValue({ data: updated, error: null });

      const result = await service.updateBySlug('test-uni', { name: 'Updated Name' } as any);

      expect(result).toEqual({ success: true, data: updated });
      expect(mockCache.del).toHaveBeenCalledWith('campus:slug:test-uni');
    });

    it('returns error when campus not found', async () => {
      mockSupabase.from.mockReturnThis();
      mockSupabase.update.mockReturnThis();
      mockSupabase.eq.mockReturnThis();
      mockSupabase.select.mockReturnThis();
      mockSupabase.single.mockResolvedValue({ data: null, error: null });

      await expect(service.updateBySlug('nonexistent', { name: 'X' } as any)).rejects.toThrow();
    });
  });

  describe('deactivateBySlug', () => {
    it('deactivates a campus', async () => {
      const deactivated = { id: '1', slug: 'test-uni', is_active: false };
      mockSupabase.from.mockReturnThis();
      mockSupabase.update.mockReturnThis();
      mockSupabase.eq.mockReturnThis();
      mockSupabase.select.mockReturnThis();
      mockSupabase.single.mockResolvedValue({ data: deactivated, error: null });

      const result = await service.deactivateBySlug('test-uni');

      expect(result).toEqual({ success: true, data: deactivated });
      expect(mockCache.del).toHaveBeenCalledWith('campus:slug:test-uni');
    });
  });

  describe('setUserCampus', () => {
    it('assigns user to an active campus', async () => {
      const campus = { id: 'campus-1', slug: 'test-uni', is_active: true };

      const localCache = { get: jest.fn().mockResolvedValue(campus), set: jest.fn(), del: jest.fn() };
      const localSupabase = { from: jest.fn(), select: jest.fn(), eq: jest.fn(), update: jest.fn(), single: jest.fn(), insert: jest.fn(), order: jest.fn() };

      localSupabase.from.mockReturnValue(localSupabase);
      localSupabase.select.mockReturnValue(localSupabase);
      localSupabase.eq.mockReturnValue(localSupabase);
      localSupabase.update.mockReturnValue(localSupabase);
      // ensureUserExists (1st call), user query (2nd), update (3rd)
      localSupabase.single
        .mockResolvedValueOnce({ data: { id: 'user-1' }, error: null })
        .mockResolvedValueOnce({ data: { campus_id: null }, error: null })
        .mockResolvedValueOnce({ data: { id: 'user-1', campus_id: 'campus-1' }, error: null });

      const localService = new CampusesService(localSupabase as any, localCache as any);

      const result = await localService.setUserCampus('user-1', 'test-uni');

      expect(result).toEqual({ success: true, data: { id: 'user-1', campus_id: 'campus-1' } });
    });

    it('skips update when user already has same campus', async () => {
      const campus = { id: 'campus-1', slug: 'test-uni', is_active: true };

      const localCache = { get: jest.fn().mockResolvedValue(campus), set: jest.fn(), del: jest.fn() };
      const localSupabase = { from: jest.fn(), select: jest.fn(), eq: jest.fn(), update: jest.fn(), single: jest.fn(), insert: jest.fn(), order: jest.fn() };

      localSupabase.from.mockReturnValue(localSupabase);
      localSupabase.select.mockReturnValue(localSupabase);
      localSupabase.eq.mockReturnValue(localSupabase);
      // ensureUserExists (1st), user query (2nd)
      localSupabase.single
        .mockResolvedValueOnce({ data: { id: 'user-1' }, error: null })
        .mockResolvedValueOnce({ data: { campus_id: 'campus-1' }, error: null });

      const localService = new CampusesService(localSupabase as any, localCache as any);

      const result = await localService.setUserCampus('user-1', 'test-uni');

      expect(result).toEqual({ success: true, data: { campus_id: 'campus-1', unchanged: true } });
    });

    it('rejects inactive campus', async () => {
      const campus = { id: 'campus-1', slug: 'inactive-uni', is_active: false };

      const localCache = { get: jest.fn().mockResolvedValue(campus), set: jest.fn(), del: jest.fn() };
      const localSupabase = { from: jest.fn(), select: jest.fn(), eq: jest.fn(), update: jest.fn(), single: jest.fn(), insert: jest.fn(), order: jest.fn() };

      localSupabase.from.mockReturnValue(localSupabase);
      localSupabase.select.mockReturnValue(localSupabase);
      localSupabase.eq.mockReturnValue(localSupabase);
      // ensureUserExists
      localSupabase.single.mockResolvedValue({ data: { id: 'user-1' }, error: null });

      const localService = new CampusesService(localSupabase as any, localCache as any);

      const result = await localService.setUserCampus('user-1', 'inactive-uni');

      expect(result.success).toBe(false);
      expect(result.error).toBe('Campus is not active');
    });

    it('rejects nonexistent campus', async () => {
      const localCache = { get: jest.fn().mockResolvedValue(undefined), set: jest.fn(), del: jest.fn() };
      const localSupabase = { from: jest.fn(), select: jest.fn(), eq: jest.fn(), update: jest.fn(), single: jest.fn(), insert: jest.fn(), order: jest.fn() };

      localSupabase.from.mockReturnValue(localSupabase);
      localSupabase.select.mockReturnValue(localSupabase);
      localSupabase.eq.mockReturnValue(localSupabase);
      // ensureUserExists
      localSupabase.single.mockResolvedValue({ data: { id: 'user-1' }, error: null });

      const localService = new CampusesService(localSupabase as any, localCache as any);

      const result = await localService.setUserCampus('user-1', 'nonexistent');

      expect(result.success).toBe(false);
    });
  });
});
