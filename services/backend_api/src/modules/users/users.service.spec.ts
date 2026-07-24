import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from './users.service';
import { SUPABASE_CLIENT } from '../../config/supabase.module';

describe('UsersService', () => {
  let service: UsersService;
  let s: any;

  beforeEach(async () => {
    s = {
      from: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      update: jest.fn().mockReturnThis(),
      eq: jest.fn().mockReturnThis(),
      single: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        { provide: SUPABASE_CLIENT, useValue: s },
      ],
    }).compile();

    service = module.get<UsersService>(UsersService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getProfile', () => {
    it('returns user data', async () => {
      const user = { id: 'u1', full_name: 'Alice', email: 'a@b.com' };
      s.single.mockResolvedValue({ data: user, error: null });

      const result = await service.getProfile('u1');

      expect(result.success).toBe(true);
      expect(result.data).toEqual(user);
      expect(s.from).toHaveBeenCalledWith('users');
    });

    it('returns fallback user when not found', async () => {
      s.single.mockResolvedValue({ data: null, error: { message: 'not found' } });

      const result = await service.getProfile('nonexistent');

      expect(result.success).toBe(true);
      expect(result.data.id).toBe('nonexistent');
      expect(result.data.full_name).toBe('EcoHabit Student');
      expect(result.data.role).toBe('student');
    });
  });

  describe('updateProfile', () => {
    it('returns updated user data', async () => {
      const updated = { id: 'u1', full_name: 'Updated Name' };
      s.single.mockResolvedValue({ data: updated, error: null });

      const result = await service.updateProfile('u1', {
        full_name: 'Updated Name',
      });

      expect(result.success).toBe(true);
      expect(result.data).toEqual(updated);
      expect(s.update).toHaveBeenCalledWith({ full_name: 'Updated Name' });
    });
  });

  describe('getUserStats', () => {
    it('aggregates listings count, points, and badges', async () => {
      const listings = [{ id: '1' }, { id: '2' }, { id: '3' }];
      const chain1 = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockImplementation(() =>
          Promise.resolve({ data: listings, error: null }),
        ),
      };
      const chain2 = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({
          data: { points: 150 },
          error: null,
        }),
      };
      const chain3 = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockImplementation(() =>
          Promise.resolve({
            data: [{ badge_type: 'first_sale' }, { badge_type: 'recycler' }],
            error: null,
          }),
        ),
      };

      s.from
        .mockReturnValueOnce(chain1)
        .mockReturnValueOnce(chain2)
        .mockReturnValueOnce(chain3);

      const result = await service.getUserStats('u1');

      expect(result.success).toBe(true);
      expect(result.data.listings_count).toBe(3);
      expect(result.data.total_points).toBe(150);
      expect(result.data.badges_count).toBe(2);
      expect(result.data.badges).toEqual(['first_sale', 'recycler']);
    });

    it('handles null/empty data gracefully', async () => {
      const emptyChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockImplementation(() =>
          Promise.resolve({ data: null, error: null }),
        ),
      };
      const pointsChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({ data: null, error: null }),
      };

      s.from
        .mockReturnValueOnce(emptyChain)
        .mockReturnValueOnce(pointsChain)
        .mockReturnValueOnce(emptyChain);

      const result = await service.getUserStats('u1');

      expect(result.data.listings_count).toBe(0);
      expect(result.data.total_points).toBe(0);
      expect(result.data.badges_count).toBe(0);
      expect(result.data.badges).toEqual([]);
    });
  });

  describe('upsertFcmToken', () => {
    it('updates the fcm_token column', async () => {
      const updateChain = {
        from: jest.fn().mockReturnThis(),
        update: jest.fn().mockReturnThis(),
        eq: jest.fn().mockImplementation(() =>
          Promise.resolve({ error: null }),
        ),
      };
      s.from.mockReturnValue(updateChain);

      const result = await service.upsertFcmToken('u1', 'fcm-token-123');

      expect(result.success).toBe(true);
      expect(updateChain.update).toHaveBeenCalledWith({ fcm_token: 'fcm-token-123' });
    });
  });
});
