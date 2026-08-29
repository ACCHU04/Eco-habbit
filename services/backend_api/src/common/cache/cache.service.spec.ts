import { Test, TestingModule } from '@nestjs/testing';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { AppCacheService, CacheKeys, CacheTTL } from './cache.service';

describe('AppCacheService', () => {
  let service: AppCacheService;
  let mockCache: any;

  beforeEach(async () => {
    mockCache = {
      get: jest.fn(),
      set: jest.fn(),
      del: jest.fn(),
      stores: [],
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AppCacheService,
        { provide: CACHE_MANAGER, useValue: mockCache },
      ],
    }).compile();

    service = module.get<AppCacheService>(AppCacheService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('get', () => {
    it('returns value from cache', async () => {
      mockCache.get.mockResolvedValue({ foo: 'bar' });

      const result = await service.get('key1');

      expect(result).toEqual({ foo: 'bar' });
      expect(mockCache.get).toHaveBeenCalledWith('key1');
    });

    it('returns undefined on cache miss', async () => {
      mockCache.get.mockResolvedValue(undefined);

      const result = await service.get('miss');

      expect(result).toBeUndefined();
    });

    it('returns undefined on error', async () => {
      mockCache.get.mockRejectedValue(new Error('connection lost'));

      const result = await service.get('bad-key');

      expect(result).toBeUndefined();
    });
  });

  describe('set', () => {
    it('stores value with TTL', async () => {
      mockCache.set.mockResolvedValue(undefined);

      await service.set('key1', { data: 1 }, 30000);

      expect(mockCache.set).toHaveBeenCalledWith('key1', { data: 1 }, 30000);
    });

    it('stores value without TTL', async () => {
      mockCache.set.mockResolvedValue(undefined);

      await service.set('key1', 'hello');

      expect(mockCache.set).toHaveBeenCalledWith('key1', 'hello', undefined);
    });

    it('does not throw on error', async () => {
      mockCache.set.mockRejectedValue(new Error('disk full'));

      await expect(service.set('key1', 'val')).resolves.toBeUndefined();
    });
  });

  describe('del', () => {
    it('removes key from cache', async () => {
      mockCache.del.mockResolvedValue(undefined);

      await service.del('key1');

      expect(mockCache.del).toHaveBeenCalledWith('key1');
    });

    it('does not throw on error', async () => {
      mockCache.del.mockRejectedValue(new Error('not found'));

      await expect(service.del('key1')).resolves.toBeUndefined();
    });
  });

  describe('invalidatePattern', () => {
    it('deletes all keys matching prefix', async () => {
      const mockStore = {
        keys: jest.fn().mockReturnValue(
          (async function* () {
            yield 'leaderboard:filtered:weekly:all';
            yield 'leaderboard:friend:u1';
            yield 'community:feed:all:1';
          })(),
        ),
      };
      mockCache.stores = [mockStore];
      mockCache.del.mockResolvedValue(undefined);

      await service.invalidatePattern('leaderboard:');

      expect(mockCache.del).toHaveBeenCalledTimes(2);
      expect(mockCache.del).toHaveBeenCalledWith('leaderboard:filtered:weekly:all');
      expect(mockCache.del).toHaveBeenCalledWith('leaderboard:friend:u1');
      expect(mockCache.del).not.toHaveBeenCalledWith('community:feed:all:1');
    });

    it('does nothing when no keys match', async () => {
      const mockStore = {
        keys: jest.fn().mockReturnValue(
          (async function* () {
            yield 'community:feed:all:1';
          })(),
        ),
      };
      mockCache.stores = [mockStore];

      await service.invalidatePattern('leaderboard:');

      expect(mockCache.del).not.toHaveBeenCalled();
    });

    it('handles store without keys method', async () => {
      mockCache.stores = [{}];

      await expect(
        service.invalidatePattern('leaderboard:'),
      ).resolves.toBeUndefined();
    });

    it('handles error gracefully', async () => {
      const failingStore = {
        keys: async function* () {
          throw new Error('store error');
        },
      };
      mockCache.stores = [failingStore];

      await expect(
        service.invalidatePattern('leaderboard:'),
      ).resolves.toBeUndefined();
    });
  });
});

describe('CacheKeys', () => {
  it('generates leaderboard keys correctly', () => {
    expect(CacheKeys.leaderboard.filtered('weekly', 'all')).toBe(
      'leaderboard:filtered:weekly:all',
    );
    expect(CacheKeys.leaderboard.friend('u123')).toBe('leaderboard:friend:u123');
    expect(CacheKeys.leaderboard.hostel('sunshine')).toBe(
      'leaderboard:hostel:sunshine',
    );
    expect(CacheKeys.leaderboard.period('daily', 'hostel', 'd1')).toBe(
      'leaderboard:period:daily:hostel:d1',
    );
  });

  it('generates community keys correctly', () => {
    expect(CacheKeys.community.feed('diy', 2)).toBe('community:feed:diy:2');
    expect(CacheKeys.community.feed('', 1)).toBe('community:feed:all:1');
    expect(CacheKeys.community.trending(10)).toBe('community:trending:10');
  });

  it('generates DIY keys correctly', () => {
    expect(CacheKeys.diy.list('upcycling', 'easy', 1)).toBe(
      'diy:list:upcycling:easy:1',
    );
    expect(CacheKeys.diy.list('', '', 1)).toBe('diy:list:all:all:1');
  });

  it('generates home keys correctly', () => {
    expect(CacheKeys.home.dashboard('u1')).toBe('home:dashboard:u1');
  });
});

describe('CacheTTL', () => {
  it('has correct TTL values', () => {
    expect(CacheTTL.LEADERBOARD).toBe(30_000);
    expect(CacheTTL.FEED).toBe(30_000);
    expect(CacheTTL.DIY).toBe(300_000);
    expect(CacheTTL.DASHBOARD).toBe(60_000);
  });
});
