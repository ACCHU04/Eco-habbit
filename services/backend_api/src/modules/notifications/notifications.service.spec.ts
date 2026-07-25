import { Test, TestingModule } from '@nestjs/testing';
import { NotificationsService } from './notifications.service';
import { SUPABASE_CLIENT } from '../../config/supabase.module';

jest.mock('../../common/helpers/user-sync.helper', () => ({
  ensureUserExists: jest.fn().mockResolvedValue(undefined),
}));

function createMockSupabase() {
  const mock: any = {};
  let chainResult: any = { data: null, error: null, count: 0 };

  mock.setResult = (result: any) => { chainResult = result; };

  const chainable = () => {
    mock.from = jest.fn().mockReturnValue(chainObj);
    mock.select = jest.fn().mockReturnValue(chainObj);
    mock.insert = jest.fn().mockReturnValue(chainObj);
    mock.update = jest.fn().mockReturnValue(chainObj);
    mock.upsert = jest.fn().mockReturnValue(chainObj);
    mock.eq = jest.fn().mockReturnValue(chainObj);
    mock.neq = jest.fn().mockReturnValue(chainObj);
    mock.is = jest.fn().mockReturnValue(chainObj);
    mock.order = jest.fn().mockReturnValue(chainObj);
    mock.range = jest.fn().mockReturnValue(chainObj);
    mock.single = jest.fn().mockImplementation(() => Promise.resolve(chainResult));
    return chainObj;
  };

  const chainObj: any = {
    get from() { return mock.from; },
    get select() { return mock.select; },
    get insert() { return mock.insert; },
    get update() { return mock.update; },
    get upsert() { return mock.upsert; },
    get eq() { return mock.eq; },
    get neq() { return mock.neq; },
    get is() { return mock.is; },
    get order() { return mock.order; },
    get range() { return mock.range; },
    get single() { return mock.single; },
    then: (resolve: any, reject?: any) => Promise.resolve(chainResult).then(resolve, reject),
  };

  chainable();
  return mock;
}

describe('NotificationsService', () => {
  let service: NotificationsService;
  let mockSupabase: any;

  beforeEach(async () => {
    mockSupabase = createMockSupabase();

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        NotificationsService,
        { provide: SUPABASE_CLIENT, useValue: mockSupabase },
      ],
    }).compile();

    service = module.get<NotificationsService>(NotificationsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('createNotification', () => {
    it('should create a notification successfully', async () => {
      const mockNotification = {
        id: 'notif-1',
        user_id: 'user-1',
        type: 'like_comment',
        title: 'New like',
        body: 'Someone liked your post',
        data: null,
        read_at: null,
        created_at: new Date().toISOString(),
      };

      mockSupabase.setResult({ data: mockNotification, error: null });

      const result = await service.createNotification(
        'user-1', 'like_comment', 'New like', 'Someone liked your post',
      );

      expect(result.success).toBe(true);
      expect(result.data).toEqual(mockNotification);
      expect(mockSupabase.from).toHaveBeenCalledWith('notifications');
      expect(mockSupabase.insert).toHaveBeenCalledWith({
        user_id: 'user-1',
        type: 'like_comment',
        title: 'New like',
        body: 'Someone liked your post',
        data: null,
      });
    });

    it('should throw on Supabase error', async () => {
      mockSupabase.setResult({ data: null, error: { message: 'insert failed' } });

      await expect(
        service.createNotification('user-1', 'like_comment', 'Title', 'Body'),
      ).rejects.toThrow('insert failed');
    });
  });

  describe('getNotifications', () => {
    it('should return paginated notifications', async () => {
      const mockData = [
        { id: '1', type: 'like_comment', title: 'Title 1', read_at: null },
      ];
      mockSupabase.setResult({ data: mockData, error: null, count: 1 });

      const result = await service.getNotifications('user-1', { page: 1, limit: 20 });

      expect(result.success).toBe(true);
      expect(result.pagination).toBeDefined();
      expect(result.pagination.page).toBe(1);
      expect(result.pagination.total).toBe(1);
    });

    it('should filter unread only when specified', async () => {
      mockSupabase.setResult({ data: [], error: null, count: 0 });

      await service.getNotifications('user-1', { unread_only: true });

      expect(mockSupabase.is).toHaveBeenCalledWith('read_at', null);
    });
  });

  describe('markAsRead', () => {
    it('should mark a notification as read', async () => {
      mockSupabase.setResult({ error: null });

      const result = await service.markAsRead('user-1', 'notif-1');

      expect(result.success).toBe(true);
      expect(mockSupabase.update).toHaveBeenCalledWith({ read_at: expect.any(String) });
      expect(mockSupabase.eq).toHaveBeenCalledWith('id', 'notif-1');
      expect(mockSupabase.eq).toHaveBeenCalledWith('user_id', 'user-1');
    });
  });

  describe('getUnreadCount', () => {
    it('should return the unread count', async () => {
      mockSupabase.setResult({ count: 5, error: null });

      const result = await service.getUnreadCount('user-1');

      expect(result.success).toBe(true);
      expect(result.unread_count).toBe(5);
    });
  });

  describe('getPreferences', () => {
    it('should return existing preferences', async () => {
      const mockPrefs = {
        user_id: 'user-1',
        like_comment: true,
        marketplace_inquiry: true,
        reward_achievement: true,
        community_update: false,
      };
      mockSupabase.setResult({ data: mockPrefs, error: null });

      const result = await service.getPreferences('user-1');

      expect(result.success).toBe(true);
      expect(result.data).toEqual(mockPrefs);
    });

    it('should create default preferences if none exist', async () => {
      const mockCreated = {
        user_id: 'user-1',
        like_comment: true,
        marketplace_inquiry: true,
        reward_achievement: true,
        community_update: false,
      };

      let callCount = 0;
      mockSupabase.single.mockImplementation(() => {
        callCount++;
        if (callCount === 1) {
          return Promise.resolve({ data: null, error: { code: 'PGRST116' } });
        }
        return Promise.resolve({ data: mockCreated, error: null });
      });

      const result = await service.getPreferences('user-1');

      expect(result.success).toBe(true);
      expect(result.data).toEqual(mockCreated);
      expect(mockSupabase.insert).toHaveBeenCalledWith({ user_id: 'user-1' });
    });
  });
});
