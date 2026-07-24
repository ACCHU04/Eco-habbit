import { Test, TestingModule } from '@nestjs/testing';
import { HomeService } from './home.service';
import { SUPABASE_CLIENT } from '../../config/supabase.module';

describe('HomeService', () => {
  let service: HomeService;
  let s: any;

  beforeEach(async () => {
    s = {
      from: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      eq: jest.fn().mockReturnThis(),
      order: jest.fn().mockReturnThis(),
      limit: jest.fn().mockReturnThis(),
      single: jest.fn(),
      rpc: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HomeService,
        { provide: SUPABASE_CLIENT, useValue: s },
      ],
    }).compile();

    service = module.get<HomeService>(HomeService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getDashboard', () => {
    it('returns assembled dashboard from parallel queries', async () => {
      const userData = { id: 'u1', full_name: 'Alice', college: 'IIT Delhi' };
      const listings = [
        { id: 'l1', title: 'Item 1', marketplace_listing_images: [{ image_url: 'img1.jpg' }] },
        { id: 'l2', title: 'Item 2', marketplace_listing_images: [] },
      ];

      const userChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({ data: userData, error: null }),
      };

      const listingsChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        order: jest.fn().mockReturnThis(),
        limit: jest.fn().mockImplementation(() =>
          Promise.resolve({ data: listings, error: null }),
        ),
      };

      s.from
        .mockReturnValueOnce(userChain)
        .mockReturnValueOnce(listingsChain);

      s.rpc.mockResolvedValue({ data: 250, error: null });

      const result = await service.getDashboard('u1');

      expect(result.success).toBe(true);
      expect(result.data.user).toEqual(userData);
      expect(result.data.points).toBe(250);
      expect(result.data.recent_listings).toHaveLength(2);
      expect(result.data.recent_listings[0].title).toBe('Item 1');
      expect(s.rpc).toHaveBeenCalledWith('get_user_points', {
        p_user_id: 'u1',
      });
    });

    it('handles null data gracefully', async () => {
      const emptyUserChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({ data: null, error: null }),
      };
      const emptyListingsChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        order: jest.fn().mockReturnThis(),
        limit: jest.fn().mockImplementation(() =>
          Promise.resolve({ data: null, error: null }),
        ),
      };

      s.from
        .mockReturnValueOnce(emptyUserChain)
        .mockReturnValueOnce(emptyListingsChain);

      s.rpc.mockResolvedValue({ data: null, error: null });

      const result = await service.getDashboard('u1');

      expect(result.success).toBe(true);
      expect(result.data.user).toEqual({
        id: 'u1',
        full_name: 'EcoHabit Student',
        college: 'Campus',
        role: 'student',
      });
      expect(result.data.points).toBe(0);
      expect(result.data.recent_listings).toEqual([]);
    });
  });
});
