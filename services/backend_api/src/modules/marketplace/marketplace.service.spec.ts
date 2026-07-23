import { Test, TestingModule } from '@nestjs/testing';
import { MarketplaceService } from './marketplace.service';
import { SUPABASE_CLIENT } from '../../config/supabase.module';

describe('MarketplaceService', () => {
  let service: MarketplaceService;
  let mockSupabase: any;

  beforeEach(async () => {
    mockSupabase = {
      from: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      insert: jest.fn().mockReturnThis(),
      update: jest.fn().mockReturnThis(),
      eq: jest.fn().mockReturnThis(),
      neq: jest.fn().mockReturnThis(),
      or: jest.fn().mockReturnThis(),
      gte: jest.fn().mockReturnThis(),
      lte: jest.fn().mockReturnThis(),
      order: jest.fn().mockReturnThis(),
      range: jest.fn().mockReturnThis(),
      single: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        MarketplaceService,
        { provide: SUPABASE_CLIENT, useValue: mockSupabase },
      ],
    }).compile();

    service = module.get<MarketplaceService>(MarketplaceService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('createListing', () => {
    it('should create a listing successfully', async () => {
      const mockListing = {
        id: 'test-id',
        title: 'Test Item',
        price: 100,
        category: 'textbooks_stationery',
        condition: 'good',
        seller_id: 'user-1',
      };

      mockSupabase.single.mockResolvedValue({ data: mockListing, error: null });

      const result = await service.createListing('user-1', {
        title: 'Test Item',
        description: 'A test item',
        price: 100,
        category: 'textbooks_stationery' as any,
        condition: 'good' as any,
      });

      expect(result.success).toBe(true);
      expect(result.data).toEqual(mockListing);
      expect(mockSupabase.from).toHaveBeenCalledWith('marketplace_listings');
    });
  });

  describe('getListings', () => {
    it('should return paginated active listings', async () => {
      const mockData = [{ id: '1', title: 'Item 1', status: 'active' }];
      mockSupabase.single.mockResolvedValue({
        data: mockData,
        error: null,
        count: 1,
      });

      const result = await service.getListings({ page: 1, limit: 20 });

      expect(result.success).toBe(true);
      expect(result.pagination).toBeDefined();
      expect(result.pagination.page).toBe(1);
    });
  });

  describe('getListingById', () => {
    it('should return a listing by id', async () => {
      const mockListing = { id: 'test-id', title: 'Test Item' };
      mockSupabase.single.mockResolvedValue({ data: mockListing, error: null });

      const result = await service.getListingById('test-id');

      expect(result.success).toBe(true);
      expect(result.data.id).toBe('test-id');
    });

    it('should throw NotFoundException for missing listing', async () => {
      mockSupabase.single.mockResolvedValue({
        data: null,
        error: { message: 'not found' },
      });

      await expect(service.getListingById('nonexistent')).rejects.toThrow();
    });
  });

  describe('updateListing', () => {
    it('should update own listing', async () => {
      mockSupabase.single
        .mockResolvedValueOnce({ data: { seller_id: 'user-1' }, error: null })
        .mockResolvedValueOnce({
          data: { id: 'test-id', title: 'Updated' },
          error: null,
        });

      const result = await service.updateListing('test-id', 'user-1', {
        title: 'Updated',
      });

      expect(result.success).toBe(true);
    });

    it('should throw ForbiddenException for other users listing', async () => {
      mockSupabase.single.mockResolvedValue({
        data: { seller_id: 'user-2' },
        error: null,
      });

      await expect(
        service.updateListing('test-id', 'user-1', { title: 'Hacked' }),
      ).rejects.toThrow('Not your listing');
    });
  });

  describe('deleteListing', () => {
    it('should soft-delete own listing', async () => {
      mockSupabase.single.mockResolvedValue({
        data: { seller_id: 'user-1' },
        error: null,
      });

      const mockUpdateChain = {
        eq: jest.fn().mockResolvedValue({ error: null }),
      };
      mockSupabase.update.mockReturnValue(mockUpdateChain);

      const result = await service.deleteListing('test-id', 'user-1');

      expect(result.success).toBe(true);
      expect(mockSupabase.update).toHaveBeenCalledWith({ status: 'removed' });
      expect(mockUpdateChain.eq).toHaveBeenCalledWith('id', 'test-id');
    });
  });
});
