import { Test, TestingModule } from '@nestjs/testing';
import { PassportService } from './passport.service';
import { SUPABASE_CLIENT } from '../../config/supabase.module';

function createMockChain(terminalResult: any) {
  const chain: any = {};
  chain.select = jest.fn().mockReturnValue(chain);
  chain.eq = jest.fn().mockReturnValue(chain);
  chain.order = jest.fn().mockReturnValue(chain);
  chain.range = jest.fn().mockReturnValue(chain);
  chain.single = jest.fn().mockReturnValue(Promise.resolve(terminalResult));
  chain.then = (resolve: any, reject?: any) =>
    Promise.resolve(terminalResult).then(resolve, reject);
  return chain;
}

describe('PassportService', () => {
  let service: PassportService;
  let s: any;

  beforeEach(async () => {
    s = { from: jest.fn() };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PassportService,
        { provide: SUPABASE_CLIENT, useValue: s },
      ],
    }).compile();

    service = module.get<PassportService>(PassportService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getImpact', () => {
    it('aggregates impact from rewards', async () => {
      const rewards = [
        { action: 'recycle_item', points: 20, coin_value: 5 },
        { action: 'recycle_item', points: 20, coin_value: 5 },
        { action: 'complete_sale', points: 50, coin_value: 10 },
        { action: 'ai_scan', points: 5, coin_value: 1 },
      ];
      const xpData = { total_xp: 4250 };

      const rewardsChain = createMockChain({ data: rewards, error: null });
      const xpChain = createMockChain({ data: xpData, error: null });

      s.from
        .mockReturnValueOnce(rewardsChain)
        .mockReturnValueOnce(xpChain);

      const result = await service.getImpact('u1');

      expect(result.success).toBe(true);
      expect(result.data.impact.co2.value).toBeCloseTo(5.7, 1);
      expect(result.data.impact.water.value).toBe(230);
      expect(result.data.actions.items_recycled).toBe(2);
      expect(result.data.actions.items_sold).toBe(1);
      expect(result.data.actions.scans_completed).toBe(1);
      expect(result.data.total_xp).toBe(4250);
      expect(result.data.level).toBe(9);
    });

    it('returns zeros when no rewards exist', async () => {
      const rewardsChain = createMockChain({ data: [], error: null });
      const xpChain = createMockChain({ data: null, error: null });

      s.from
        .mockReturnValueOnce(rewardsChain)
        .mockReturnValueOnce(xpChain);

      const result = await service.getImpact('u1');

      expect(result.success).toBe(true);
      expect(result.data.impact.co2.value).toBe(0);
      expect(result.data.actions.items_recycled).toBe(0);
    });
  });

  describe('getTimeline', () => {
    it('returns paginated timeline', async () => {
      const timeline = [
        { id: 'r1', action: 'list_item', points: 10, coin_value: 2, created_at: '2026-07-25T10:00:00Z' },
      ];
      const chain = createMockChain({ data: timeline, error: null, count: 15 });
      s.from.mockReturnValue(chain);

      const result = await service.getTimeline('u1', 1, 20);

      expect(result.success).toBe(true);
      expect(result.data).toEqual(timeline);
      expect(result.pagination).toEqual({ page: 1, limit: 20, total: 15, total_pages: 1 });
    });
  });

  describe('getStreak', () => {
    it('computes streak from activity dates', async () => {
      const today = new Date();
      const yesterday = new Date(today);
      yesterday.setDate(yesterday.getDate() - 1);
      const twoDaysAgo = new Date(today);
      twoDaysAgo.setDate(twoDaysAgo.getDate() - 2);

      const formatDate = (d: Date) => d.toISOString();

      const rewards = [
        { created_at: formatDate(today) },
        { created_at: formatDate(yesterday) },
        { created_at: formatDate(twoDaysAgo) },
      ];

      s.from.mockReturnValue(createMockChain({ data: rewards, error: null }));

      const result = await service.getStreak('u1');

      expect(result.success).toBe(true);
      expect(result.data.current_streak).toBe(3);
      expect(result.data.longest_streak).toBe(3);
    });

    it('returns 0 streak when no activity', async () => {
      s.from.mockReturnValue(createMockChain({ data: [], error: null }));

      const result = await service.getStreak('u1');

      expect(result.success).toBe(true);
      expect(result.data.current_streak).toBe(0);
    });
  });
});
