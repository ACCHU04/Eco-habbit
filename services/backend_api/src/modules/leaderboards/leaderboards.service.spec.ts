import { Test, TestingModule } from '@nestjs/testing';
import { LeaderboardsService } from './leaderboards.service';

describe('LeaderboardsService', () => {
  let service: LeaderboardsService;

  const mockSupabase = {
    rpc: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        LeaderboardsService,
        { provide: 'SUPABASE_CLIENT', useValue: mockSupabase },
      ],
    }).compile();

    service = module.get<LeaderboardsService>(LeaderboardsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getFilteredLeaderboard', () => {
    it('should return leaderboard data', async () => {
      mockSupabase.rpc.mockResolvedValue({
        data: [
          { user_id: 'u1', full_name: 'Alice', total_points: 500, level: 5, badge_count: 3, rank: 1 },
          { user_id: 'u2', full_name: 'Bob', total_points: 300, level: 3, badge_count: 2, rank: 2 },
        ],
        error: null,
      });

      const result = await service.getFilteredLeaderboard('campus');

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(2);
      expect(mockSupabase.rpc).toHaveBeenCalledWith('get_filtered_leaderboard', {
        filter_type: 'campus',
        filter_value: null,
        result_limit: 50,
      });
    });

    it('should handle errors gracefully', async () => {
      mockSupabase.rpc.mockResolvedValue({ data: null, error: { message: 'DB error' } });

      const result = await service.getFilteredLeaderboard();

      expect(result.success).toBe(true);
      expect(result.data).toEqual([]);
    });
  });

  describe('getFriendLeaderboard', () => {
    it('should return friend leaderboard', async () => {
      mockSupabase.rpc.mockResolvedValue({
        data: [{ user_id: 'u1', full_name: 'Alice', total_points: 500, level: 5, rank: 1 }],
        error: null,
      });

      const result = await service.getFriendLeaderboard('user-1');

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(1);
      expect(mockSupabase.rpc).toHaveBeenCalledWith('get_friend_leaderboard', {
        p_user_id: 'user-1',
        result_limit: 50,
      });
    });
  });

  describe('getHostelLeaderboard', () => {
    it('should return hostel leaderboard', async () => {
      mockSupabase.rpc.mockResolvedValue({
        data: [{ hostel_id: 'h1', hostel_name: 'Block A', total_score: 1000, member_count: 50, avg_score: 20, rank: 1 }],
        error: null,
      });

      const result = await service.getHostelLeaderboard();

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(1);
      expect(mockSupabase.rpc).toHaveBeenCalledWith('get_hostel_leaderboard', {
        p_college: null,
        result_limit: 50,
      });
    });
  });

  describe('getPeriodLeaderboard', () => {
    it('should return period leaderboard', async () => {
      mockSupabase.rpc.mockResolvedValue({
        data: [{ user_id: 'u1', full_name: 'Alice', total_points: 100, rank: 1 }],
        error: null,
      });

      const result = await service.getPeriodLeaderboard('weekly');

      expect(result.success).toBe(true);
      expect(mockSupabase.rpc).toHaveBeenCalledWith('get_period_leaderboard', {
        period: 'weekly',
        filter_type: 'campus',
        filter_value: null,
        result_limit: 50,
      });
    });
  });

  describe('getUserRank', () => {
    it('should return user rank', async () => {
      mockSupabase.rpc.mockResolvedValue({
        data: [
          { user_id: 'u1', full_name: 'Alice', total_points: 500, level: 5, rank: 1 },
          { user_id: 'u2', full_name: 'Bob', total_points: 300, level: 3, rank: 2 },
        ],
        error: null,
      });

      const result = await service.getUserRank('u1');

      expect(result.success).toBe(true);
      expect(result.data).toEqual(
        expect.objectContaining({ user_id: 'u1', rank: 1 }),
      );
    });

    it('should return default rank for unknown user', async () => {
      mockSupabase.rpc.mockResolvedValue({
        data: [],
        error: null,
      });

      const result = await service.getUserRank('unknown');

      expect(result.success).toBe(true);
      expect(result.data.rank).toBe(0);
    });
  });
});
