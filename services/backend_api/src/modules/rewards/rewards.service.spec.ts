import { Test, TestingModule } from '@nestjs/testing';
import { RewardsService, POINTS_RULES, COIN_RULES } from './rewards.service';
import { SUPABASE_CLIENT } from '../../config/supabase.module';

jest.mock('../../common/helpers/user-sync.helper', () => ({
  ensureUserExists: jest.fn().mockResolvedValue(undefined),
}));

describe('RewardsService', () => {
  let service: RewardsService;
  let s: any;

  beforeEach(async () => {
    s = {
      from: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      insert: jest.fn().mockReturnThis(),
      upsert: jest.fn().mockReturnThis(),
      eq: jest.fn().mockReturnThis(),
      order: jest.fn().mockReturnThis(),
      range: jest.fn().mockReturnThis(),
      single: jest.fn(),
      rpc: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        RewardsService,
        { provide: SUPABASE_CLIENT, useValue: s },
      ],
    }).compile();

    service = module.get<RewardsService>(RewardsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('POINTS_RULES', () => {
    it('exports 10 action types', () => {
      expect(Object.keys(POINTS_RULES)).toHaveLength(10);
    });

    it('has expected point values', () => {
      expect(POINTS_RULES.list_item).toBe(10);
      expect(POINTS_RULES.complete_sale).toBe(50);
      expect(POINTS_RULES.ai_scan).toBe(5);
    });
  });

  describe('COIN_RULES', () => {
    it('exports coin values for known actions', () => {
      expect(COIN_RULES.list_item).toBe(2);
      expect(COIN_RULES.complete_sale).toBe(10);
      expect(COIN_RULES.recycle_item).toBe(5);
      expect(COIN_RULES.like_post).toBe(0);
    });
  });

  describe('awardPoints', () => {
    it('inserts reward with correct points and coin_value for known action', async () => {
      const mockReward = { id: 'r1', user_id: 'u1', action: 'list_item', points: 10, coin_value: 2 };
      s.single.mockResolvedValue({ data: mockReward, error: null });

      const result = await service.awardPoints('u1', 'list_item');

      expect(result.success).toBe(true);
      expect(result.points).toBe(10);
      expect(s.from).toHaveBeenCalledWith('eco_rewards');
      expect(s.insert).toHaveBeenCalledWith({
        user_id: 'u1',
        points: 10,
        action: 'list_item',
        coin_value: 2,
      });
    });

    it('uses customPoints when provided', async () => {
      const mockReward = { id: 'r2', user_id: 'u1', action: 'bonus', points: 100, coin_value: 0 };
      s.single.mockResolvedValue({ data: mockReward, error: null });

      const result = await service.awardPoints('u1', 'bonus', 100);

      expect(result.points).toBe(100);
      expect(s.insert).toHaveBeenCalledWith({
        user_id: 'u1',
        points: 100,
        action: 'bonus',
        coin_value: 0,
      });
    });

    it('returns 0 points without DB insert for unknown action', async () => {
      const result = await service.awardPoints('u1', 'unknown_action');

      expect(result.success).toBe(true);
      expect(result.points).toBe(0);
      expect(s.insert).not.toHaveBeenCalled();
    });

    it('throws on Supabase insert error', async () => {
      s.single.mockResolvedValue({ data: null, error: { message: 'insert failed' } });

      await expect(service.awardPoints('u1', 'list_item')).rejects.toThrow(
        'insert failed',
      );
    });
  });

  describe('getTotalPoints', () => {
    it('sums all reward points for a user', async () => {
      s.data = [{ points: 10 }, { points: 20 }, { points: 5 }];
      s.error = null;

      const result = await service.getTotalPoints('u1');

      expect(result.success).toBe(true);
      expect(result.total_points).toBe(35);
    });

    it('returns 0 when no rewards exist', async () => {
      s.data = [];
      s.error = null;

      const result = await service.getTotalPoints('u1');

      expect(result.total_points).toBe(0);
    });
  });

  describe('getPointsHistory', () => {
    it('returns paginated data with correct pagination', async () => {
      const rewards = [{ id: '1', action: 'list_item', points: 10 }];
      s.data = rewards;
      s.error = null;
      s.count = 25;

      const result = await service.getPointsHistory('u1', 2, 10);

      expect(result.success).toBe(true);
      expect(result.data).toEqual(rewards);
      expect(result.pagination).toEqual({
        page: 2,
        limit: 10,
        total: 25,
        total_pages: 3,
      });
    });
  });

  describe('getLeaderboard', () => {
    it('returns RPC data on success', async () => {
      const leaderboard = [{ user_id: 'u1', total_points: 100 }];
      s.rpc.mockResolvedValue({ data: leaderboard, error: null });

      const result = await service.getLeaderboard(10);

      expect(result.success).toBe(true);
      expect(result.data).toEqual(leaderboard);
      expect(s.rpc).toHaveBeenCalledWith('get_leaderboard', {
        result_limit: 10,
      });
    });

    it('falls back to aggregation when RPC fails', async () => {
      s.rpc.mockResolvedValue({ data: null, error: { message: 'rpc failed' } });

      const fallbackData = [
        { user_id: 'u1', points: 30, users: { id: 'u1', full_name: 'Alice' } },
        { user_id: 'u2', points: 20, users: { id: 'u2', full_name: 'Bob' } },
        { user_id: 'u1', points: 10, users: { id: 'u1', full_name: 'Alice' } },
      ];

      const fallbackChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        order: jest.fn().mockReturnThis(),
        limit: jest.fn().mockImplementation(() =>
          Promise.resolve({ data: fallbackData, error: null }),
        ),
        eq: jest.fn().mockReturnThis(),
      };

      s.from.mockReturnValueOnce(fallbackChain);

      const result = await service.getLeaderboard(50);

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(2);
      expect(result.data[0].user_id).toBe('u1');
      expect(result.data[0].total_points).toBe(40);
      expect(result.data[1].user_id).toBe('u2');
      expect(result.data[1].total_points).toBe(20);
    });
  });

  describe('getBadges', () => {
    it('returns user badges', async () => {
      const badges = [
        { badge_type: 'first_sale', earned_at: '2026-01-01' },
        { badge_type: 'recycler', earned_at: '2026-02-01' },
      ];
      s.data = badges;
      s.error = null;

      const result = await service.getBadges('u1');

      expect(result.success).toBe(true);
      expect(result.data).toEqual(badges);
    });
  });
});
