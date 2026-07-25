import { Test, TestingModule } from '@nestjs/testing';
import { CoinsService } from './coins.service';
import { SUPABASE_CLIENT } from '../../config/supabase.module';

describe('CoinsService', () => {
  let service: CoinsService;
  let s: any;

  beforeEach(async () => {
    s = {
      from: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      eq: jest.fn().mockReturnThis(),
      order: jest.fn().mockReturnThis(),
      range: jest.fn().mockReturnThis(),
      single: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CoinsService,
        { provide: SUPABASE_CLIENT, useValue: s },
      ],
    }).compile();

    service = module.get<CoinsService>(CoinsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getBalance', () => {
    it('returns correct balance from coin_value field', async () => {
      const xpChain = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({ data: { total_xp: 500, level: 3 }, error: null }),
      };

      const rewardsChain = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockResolvedValue({ data: [{ coin_value: 10 }, { coin_value: 25 }, { coin_value: 5 }], error: null }),
      };

      s.from
        .mockReset()
        .mockReturnValueOnce(xpChain)
        .mockReturnValueOnce(rewardsChain);

      const result = await service.getBalance('u1');

      expect(result.success).toBe(true);
      expect(result.data.balance).toBe(40);
      expect(result.data.level).toBe(3);
      expect(result.data.total_xp).toBe(500);
    });

    it('returns zero balance for new user', async () => {
      const xpChain = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({ data: null, error: null }),
      };

      const rewardsChain = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockResolvedValue({ data: [], error: null }),
      };

      s.from
        .mockReset()
        .mockReturnValueOnce(xpChain)
        .mockReturnValueOnce(rewardsChain);

      const result = await service.getBalance('u1');

      expect(result.success).toBe(true);
      expect(result.data.balance).toBe(0);
      expect(result.data.level).toBe(1);
      expect(result.data.total_xp).toBe(0);
    });

    it('handles null coin_value gracefully', async () => {
      const xpChain = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({ data: { total_xp: 100, level: 1 }, error: null }),
      };

      const rewardsChain = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockResolvedValue({ data: [{ coin_value: null }, { coin_value: 10 }], error: null }),
      };

      s.from
        .mockReset()
        .mockReturnValueOnce(xpChain)
        .mockReturnValueOnce(rewardsChain);

      const result = await service.getBalance('u1');

      expect(result.data.balance).toBe(10);
    });
  });

  describe('getHistory', () => {
    it('returns paginated transaction history', async () => {
      const mockData = [
        { id: 'r1', action: 'list_item', coin_value: 10, points: 10, created_at: '2026-07-25T10:00:00Z' },
        { id: 'r2', action: 'recycle_item', coin_value: 20, points: 20, created_at: '2026-07-25T09:00:00Z' },
      ];

      const chain = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        order: jest.fn().mockReturnThis(),
        range: jest.fn().mockResolvedValue({ data: mockData, error: null, count: 2 }),
      };

      s.from.mockReturnValue(chain);

      const result = await service.getHistory('u1', 1, 20);

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(2);
      expect(result.data[0].description).toBe('Listed an item for sale');
      expect(result.data[1].description).toBe('Recycled an item');
      expect(result.pagination).toEqual({ page: 1, limit: 20, total: 2, total_pages: 1 });
    });

    it('returns empty array on error', async () => {
      const chain = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        order: jest.fn().mockReturnThis(),
        range: jest.fn().mockRejectedValue(new Error('db error')),
      };

      s.from.mockReturnValue(chain);

      const result = await service.getHistory('u1');

      expect(result.success).toBe(true);
      expect(result.data).toEqual([]);
    });

    it('maps quest_complete actions correctly', async () => {
      const mockData = [
        { id: 'r1', action: 'quest_complete:scan_item', coin_value: 5, points: 25, created_at: '2026-07-25T10:00:00Z' },
      ];

      const chain = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        order: jest.fn().mockReturnThis(),
        range: jest.fn().mockResolvedValue({ data: mockData, error: null, count: 1 }),
      };

      s.from.mockReturnValue(chain);

      const result = await service.getHistory('u1');

      expect(result.data[0].description).toBe('Completed a quest');
    });

    it('returns unknown action description as-is', async () => {
      const mockData = [
        { id: 'r1', action: 'custom_bonus', coin_value: 50, points: 50, created_at: '2026-07-25T10:00:00Z' },
      ];

      const chain = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        order: jest.fn().mockReturnThis(),
        range: jest.fn().mockResolvedValue({ data: mockData, error: null, count: 1 }),
      };

      s.from.mockReturnValue(chain);

      const result = await service.getHistory('u1');

      expect(result.data[0].description).toBe('custom_bonus');
    });
  });
});
