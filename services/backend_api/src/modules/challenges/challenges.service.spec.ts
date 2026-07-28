import { Test, TestingModule } from '@nestjs/testing';
import { ChallengesService } from './challenges.service';

jest.mock('../../common/helpers/user-sync.helper', () => ({
  ensureUserExists: jest.fn().mockResolvedValue(undefined),
}));

describe('ChallengesService', () => {
  let service: ChallengesService;

  const mockSupabase = {
    from: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ChallengesService,
        { provide: 'SUPABASE_CLIENT', useValue: mockSupabase },
      ],
    }).compile();

    service = module.get<ChallengesService>(ChallengesService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getFriends', () => {
    it('should return friends list', async () => {
      const mockQuery = {
        select: jest.fn().mockReturnThis(),
        or: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        then: jest.fn((resolve) =>
          resolve({
            data: [
              {
                id: 'f1',
                status: 'accepted',
                created_at: '2026-01-01',
                requester: { id: 'u1', full_name: 'Alice', profile_photo: null },
                addressee: { id: 'u2', full_name: 'Bob', profile_photo: null },
              },
            ],
            error: null,
          }),
        ),
      };
      mockSupabase.from.mockReturnValue(mockQuery);

      const result = await service.getFriends('u1');

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(1);
      expect(result.data[0].friend.full_name).toBe('Bob');
    });
  });

  describe('sendFriendRequest', () => {
    it('should create friend request', async () => {
      const mockSelectQuery = {
        select: jest.fn().mockReturnThis(),
        or: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        maybeSingle: jest.fn().mockResolvedValue({ data: null, error: null }),
      };

      const mockInsertQuery = {
        insert: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({
          data: { id: 'f1', requester_id: 'u1', addressee_id: 'u2', status: 'pending' },
          error: null,
        }),
      };

      mockSupabase.from
        .mockReturnValueOnce(mockSelectQuery)
        .mockReturnValueOnce(mockInsertQuery);

      const result = await service.sendFriendRequest('u1', 'u2');

      expect(result.success).toBe(true);
    });
  });

  describe('respondToFriendRequest', () => {
    it('should accept friend request', async () => {
      const mockSelectQuery = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({
          data: { id: 'f1', status: 'pending', addressee_id: 'u2' },
          error: null,
        }),
      };

      const mockUpdateQuery = {
        update: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({
          data: { id: 'f1', status: 'accepted' },
          error: null,
        }),
      };

      mockSupabase.from
        .mockReturnValueOnce(mockSelectQuery)
        .mockReturnValueOnce(mockUpdateQuery);

      const result = await service.respondToFriendRequest('u2', 'f1', true);

      expect(result.success).toBe(true);
    });
  });

  describe('createChallenge', () => {
    it('should create challenge', async () => {
      const mockInsertQuery = {
        insert: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({
          data: {
            id: 'c1',
            title: 'Recycle Challenge',
            challenger_id: 'u1',
            challengee_id: 'u2',
            goal_action: 'recycle_item',
            goal_count: 5,
            status: 'pending',
          },
          error: null,
        }),
      };

      mockSupabase.from.mockReturnValue(mockInsertQuery);

      const result = await service.createChallenge(
        'u1', 'u2', 'Recycle Challenge', 'Recycle 5 items',
        'recycle_item', 5, 7, 100, 25,
      );

      expect(result.success).toBe(true);
      expect(result.data.title).toBe('Recycle Challenge');
    });
  });

  describe('updateChallengeProgress', () => {
    it('should update progress', async () => {
      const mockSelectQuery = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({
          data: {
            id: 'c1',
            challenger_id: 'u1',
            challengee_id: 'u2',
            challenger_progress: 2,
            challengee_progress: 3,
            goal_count: 5,
            status: 'active',
          },
          error: null,
        }),
      };

      const mockUpdateQuery = {
        update: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({
          data: { id: 'c1', challenger_progress: 3, status: 'active' },
          error: null,
        }),
      };

      mockSupabase.from
        .mockReturnValueOnce(mockSelectQuery)
        .mockReturnValueOnce(mockUpdateQuery);

      const result = await service.updateChallengeProgress('u1', 'c1', 1);

      expect(result.success).toBe(true);
    });

    it('should complete challenge when goal met', async () => {
      const mockSelectQuery = {
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({
          data: {
            id: 'c1',
            challenger_id: 'u1',
            challengee_id: 'u2',
            challenger_progress: 4,
            challengee_progress: 3,
            goal_count: 5,
            status: 'active',
          },
          error: null,
        }),
      };

      const mockUpdateQuery = {
        update: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({
          data: { id: 'c1', challenger_progress: 5, status: 'completed', winner_id: 'u1' },
          error: null,
        }),
      };

      mockSupabase.from
        .mockReturnValueOnce(mockSelectQuery)
        .mockReturnValueOnce(mockUpdateQuery);

      const result = await service.updateChallengeProgress('u1', 'c1', 1);

      expect(result.success).toBe(true);
    });
  });
});
