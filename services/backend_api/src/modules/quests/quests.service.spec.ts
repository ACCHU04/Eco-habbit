import { Test, TestingModule } from '@nestjs/testing';
import { QuestsService } from './quests.service';
import { SUPABASE_CLIENT } from '../../config/supabase.module';
import { ensureUserExists } from '../../common/helpers/user-sync.helper';

jest.mock('../../common/helpers/user-sync.helper', () => ({
  ensureUserExists: jest.fn().mockResolvedValue(undefined),
}));

function createMockChain(terminalResult: any) {
  const chain: any = {};
  chain.select = jest.fn().mockReturnValue(chain);
  chain.eq = jest.fn().mockReturnValue(chain);
  chain.gte = jest.fn().mockReturnValue(chain);
  chain.not = jest.fn().mockReturnValue(chain);
  chain.order = jest.fn().mockReturnValue(chain);
  chain.range = jest.fn().mockReturnValue(chain);
  chain.single = jest.fn().mockReturnValue(Promise.resolve(terminalResult));
  chain.insert = jest.fn().mockReturnValue(Promise.resolve(terminalResult));
  chain.update = jest.fn().mockReturnValue(Promise.resolve(terminalResult));
  chain.upsert = jest.fn().mockReturnValue(Promise.resolve(terminalResult));
  chain.then = (resolve: any, reject?: any) =>
    Promise.resolve(terminalResult).then(resolve, reject);
  return chain;
}

describe('QuestsService', () => {
  let service: QuestsService;
  let s: any;

  beforeEach(async () => {
    s = {
      from: jest.fn(),
      rpc: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        QuestsService,
        { provide: SUPABASE_CLIENT, useValue: s },
      ],
    }).compile();

    service = module.get<QuestsService>(QuestsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getTodayQuests', () => {
    it('returns daily quests with user progress', async () => {
      const mockQuests = [
        { id: 'q1', title: 'First Scan', quest_type: 'daily', xp_reward: 25, coin_reward: 5, difficulty: 'easy', target_action: 'scan_item', target_count: 1, description: 'Scan', is_active: true, created_at: '' },
      ];
      const mockProgress = [
        { quest_id: 'q1', current_count: 1, completed_at: '2026-07-25T10:00:00Z' },
      ];

      const questChain = createMockChain({ data: mockQuests, error: null });
      const progressChain = createMockChain({ data: mockProgress, error: null });

      s.from
        .mockReturnValueOnce(questChain)
        .mockReturnValueOnce(progressChain);

      const result = await service.getTodayQuests('u1');

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(1);
      expect(result.data[0].completed).toBe(true);
      expect(result.data[0].progress).toBe(1);
    });

    it('returns empty array on error', async () => {
      s.from.mockReturnValue(createMockChain({ data: null, error: { message: 'db error' } }));

      const result = await service.getTodayQuests('u1');
      expect(result.success).toBe(true);
      expect(result.data).toEqual([]);
    });
  });

  describe('getAllQuests', () => {
    it('returns all active quests', async () => {
      const mockQuests = [
        { id: 'q1', title: 'First Scan', quest_type: 'daily', xp_reward: 25, coin_reward: 5, difficulty: 'easy', target_action: 'scan_item', target_count: 1, description: 'Scan', is_active: true, created_at: '' },
        { id: 'q3', title: 'Sell Three', quest_type: 'weekly', xp_reward: 200, coin_reward: 50, difficulty: 'medium', target_action: 'complete_sale', target_count: 3, description: 'Sell', is_active: true, created_at: '' },
      ];

      const questChain = createMockChain({ data: mockQuests, error: null });
      const progressChain = createMockChain({ data: [], error: null });

      s.from
        .mockReturnValueOnce(questChain)
        .mockReturnValueOnce(progressChain);

      const result = await service.getAllQuests('u1');

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(2);
      expect(result.data[0].quest_type).toBe('daily');
      expect(result.data[1].quest_type).toBe('weekly');
    });
  });

  describe('getQuestHistory', () => {
    it('returns paginated completed quest history', async () => {
      const mockData = [
        { id: 'p1', quest_id: 'q1', current_count: 1, completed_at: '2026-07-25T10:00:00Z', eco_quests: { title: 'First Scan' } },
      ];

      const chain = createMockChain({ data: mockData, error: null, count: 1 });
      s.from.mockReturnValue(chain);

      const result = await service.getQuestHistory('u1', 1, 20);

      expect(result.success).toBe(true);
      expect(result.data).toEqual(mockData);
      expect(result.pagination).toEqual({ page: 1, limit: 20, total: 1, total_pages: 1 });
    });

    it('returns empty on error', async () => {
      s.from.mockReturnValue(createMockChain({ data: null, error: { message: 'db error' }, count: 0 }));

      const result = await service.getQuestHistory('u1');
      expect(result.success).toBe(true);
      expect(result.data).toEqual([]);
    });
  });

  describe('updateQuestProgress', () => {
    it('increments progress and awards on completion', async () => {
      const mockQuest = {
        id: 'q1',
        title: 'First Scan',
        xp_reward: 25,
        coin_reward: 5,
        target_count: 1,
        target_action: 'scan_item',
      };

      const questChain = createMockChain({ data: mockQuest, error: null });
      const progressChain = createMockChain({ data: null, error: null });
      const insertChain = createMockChain({ error: null });
      const rewardInsertChain = createMockChain({ error: null });
      const xpChain = createMockChain({ data: { total_xp: 0, level: 1 }, error: null });
      const xpUpsertChain = createMockChain({ error: null });

      s.from
        .mockReturnValueOnce(questChain)
        .mockReturnValueOnce(progressChain)
        .mockReturnValueOnce(insertChain)
        .mockReturnValueOnce(rewardInsertChain)
        .mockReturnValueOnce(xpChain)
        .mockReturnValueOnce(xpUpsertChain);

      const result = await service.updateQuestProgress('u1', 'q1');

      expect(result.success).toBe(true);
      expect(result.data.xp_awarded).toBe(25);
      expect(result.data.coins_awarded).toBe(5);
    });

    it('throws NotFoundException for invalid quest', async () => {
      s.from.mockReturnValue(createMockChain({ data: null, error: { message: 'not found' } }));

      await expect(service.updateQuestProgress('u1', 'invalid')).rejects.toThrow('Quest not found');
    });

    it('returns no rewards for already-completed quest', async () => {
      const mockQuest = {
        id: 'q1',
        xp_reward: 25,
        coin_reward: 5,
        target_count: 1,
        target_action: 'scan_item',
      };
      const existingProgress = {
        id: 'p1',
        quest_id: 'q1',
        current_count: 1,
        completed_at: '2026-07-25T10:00:00Z',
      };

      const questChain = createMockChain({ data: mockQuest, error: null });
      const progressChain = createMockChain({ data: existingProgress, error: null });

      s.from
        .mockReturnValueOnce(questChain)
        .mockReturnValueOnce(progressChain);

      const result = await service.updateQuestProgress('u1', 'q1');

      expect(result.success).toBe(true);
      expect(result.data.xp_awarded).toBe(0);
      expect(result.data.coins_awarded).toBe(0);
    });
  });
});
