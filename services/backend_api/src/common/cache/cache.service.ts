import { Injectable, Inject, Logger } from '@nestjs/common';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import type { Cache } from 'cache-manager';

export const CacheKeys = {
  leaderboard: {
    filtered: (filter: string, value: string) =>
      `leaderboard:filtered:${filter}:${value || 'all'}`,
    friend: (userId: string) => `leaderboard:friend:${userId}`,
    hostel: (college: string) => `leaderboard:hostel:${college || 'all'}`,
    period: (period: string, filter: string, value: string) =>
      `leaderboard:period:${period}:${filter}:${value || 'all'}`,
  },
  community: {
    feed: (type: string, page: number) =>
      `community:feed:${type || 'all'}:${page}`,
    trending: (limit: number) => `community:trending:${limit}`,
  },
  diy: {
    list: (category: string, difficulty: string, page: number) =>
      `diy:list:${category || 'all'}:${difficulty || 'all'}:${page}`,
  },
  home: {
    dashboard: (userId: string) => `home:dashboard:${userId}`,
  },
  campus: {
    list: () => 'campus:list:active',
    bySlug: (slug: string) => `campus:slug:${slug}`,
  },
  disposal: {
    tips: (category: string) => `disposal:tips:${category}`,
    all: () => 'disposal:tips:all',
  },
} as const;

export const CacheTTL = {
  LEADERBOARD: 30_000,
  FEED: 30_000,
  DIY: 300_000,
  DASHBOARD: 60_000,
  CAMPUS: 300_000,
  DISPOSAL: 300_000,
} as const;

@Injectable()
export class AppCacheService {
  private readonly logger = new Logger('Cache');

  constructor(@Inject(CACHE_MANAGER) private readonly cache: Cache) {}

  async get<T>(key: string): Promise<T | undefined> {
    try {
      return await this.cache.get<T>(key);
    } catch {
      return undefined;
    }
  }

  async set(key: string, value: unknown, ttl?: number): Promise<void> {
    try {
      await this.cache.set(key, value, ttl);
    } catch (err) {
      this.logger.warn(`Cache set failed for ${key}: ${(err as Error).message}`);
    }
  }

  async del(key: string): Promise<void> {
    try {
      await this.cache.del(key);
    } catch (err) {
      this.logger.warn(`Cache del failed for ${key}: ${(err as Error).message}`);
    }
  }

  async invalidatePattern(pattern: string): Promise<void> {
    try {
      for (const store of this.cache.stores) {
        const storeAny = store as any;
        if (typeof storeAny.keys === 'function') {
          const keys: string[] = [];
          for await (const key of storeAny.keys()) {
            if (key.startsWith(pattern)) keys.push(key);
          }
          for (const key of keys) {
            await this.cache.del(key);
          }
          if (keys.length > 0) {
            this.logger.log(`Invalidated ${keys.length} cache keys matching "${pattern}"`);
          }
        }
      }
    } catch (err) {
      this.logger.warn(`Cache invalidatePattern failed: ${(err as Error).message}`);
    }
  }
}
