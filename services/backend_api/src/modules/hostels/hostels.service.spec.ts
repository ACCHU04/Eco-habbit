import { Test, TestingModule } from '@nestjs/testing';
import { HostelsService } from './hostels.service';

function createChainableMock(result: { data: any; error: any }) {
  const mock: any = {
    select: jest.fn().mockReturnThis(),
    order: jest.fn().mockReturnThis(),
    eq: jest.fn().mockReturnThis(),
    insert: jest.fn().mockReturnThis(),
    update: jest.fn().mockReturnThis(),
    single: jest.fn().mockResolvedValue(result),
    in: jest.fn().mockReturnThis(),
    or: jest.fn().mockReturnThis(),
  };

  // Make the object thenable so `await` resolves correctly
  mock.then = (resolve: any, reject?: any) => {
    return Promise.resolve(result).then(resolve, reject);
  };

  return mock;
}

describe('HostelsService', () => {
  let service: HostelsService;

  const mockSupabase = {
    from: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        HostelsService,
        { provide: 'SUPABASE_CLIENT', useValue: mockSupabase },
      ],
    }).compile();

    service = module.get<HostelsService>(HostelsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getAllHostels', () => {
    it('should return hostels', async () => {
      const expected = [{ id: 'h1', name: 'Block A', college: 'IIT', total_score: 1000, member_count: 50 }];
      mockSupabase.from.mockReturnValue(createChainableMock({ data: expected, error: null }));

      const result = await service.getAllHostels();

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(1);
      expect(result.data[0].name).toBe('Block A');
    });

    it('should handle college filter', async () => {
      const mockQuery = createChainableMock({ data: [], error: null });
      mockSupabase.from.mockReturnValue(mockQuery);

      await service.getAllHostels('IIT');

      expect(mockQuery.eq).toHaveBeenCalledWith('college', 'IIT');
    });

    it('should handle errors', async () => {
      mockSupabase.from.mockReturnValue(createChainableMock({ data: null, error: { message: 'DB error' } }));

      const result = await service.getAllHostels();

      expect(result.success).toBe(true);
      expect(result.data).toEqual([]);
    });
  });

  describe('joinHostel', () => {
    it('should update user hostel', async () => {
      const mockUpdateQuery = {
        update: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({
          data: { id: 'u1', hostel: 'Block A' },
          error: null,
        }),
      };
      mockSupabase.from.mockReturnValue(mockUpdateQuery);

      const result = await service.joinHostel('u1', 'Block A');

      expect(result.success).toBe(true);
    });
  });

  describe('getActiveBattles', () => {
    it('should return battles', async () => {
      const expected = [{ id: 'b1', title: 'Test Battle', status: 'active' }];
      mockSupabase.from.mockReturnValue(createChainableMock({ data: expected, error: null }));

      const result = await service.getActiveBattles();

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(1);
    });
  });
});
