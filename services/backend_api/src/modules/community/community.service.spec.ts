import { Test, TestingModule } from '@nestjs/testing';
import { CommunityService } from './community.service';
import { SUPABASE_CLIENT } from '../../config/supabase.module';

describe('CommunityService', () => {
  let service: CommunityService;
  let mockSupabase: any;

  beforeEach(async () => {
    mockSupabase = {
      from: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      insert: jest.fn().mockReturnThis(),
      update: jest.fn().mockReturnThis(),
      delete: jest.fn().mockReturnThis(),
      eq: jest.fn().mockReturnThis(),
      order: jest.fn().mockReturnThis(),
      range: jest.fn().mockReturnThis(),
      single: jest.fn(),
      rpc: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CommunityService,
        { provide: SUPABASE_CLIENT, useValue: mockSupabase },
      ],
    }).compile();

    service = module.get<CommunityService>(CommunityService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getFeed', () => {
    it('should return paginated posts', async () => {
      const mockPosts = [
        { id: '1', content: 'Hello', post_type: 'diy', likes_count: 5, comments_count: 2 },
      ];
      mockSupabase.data = mockPosts;
      mockSupabase.error = null;
      mockSupabase.count = 1;

      const result = await service.getFeed({ page: 1, limit: 20 });

      expect(result.success).toBe(true);
      expect(result.pagination).toBeDefined();
      expect(result.pagination.page).toBe(1);
    });

    it('should include posts with zero likes (left join)', async () => {
      const mockPosts = [
        { id: '1', content: 'New post', post_type: 'tip', likes_count: 0, comments_count: 0, post_likes: [] },
      ];
      mockSupabase.data = mockPosts;
      mockSupabase.error = null;
      mockSupabase.count = 1;

      const result = await service.getFeed({ page: 1, limit: 20 });

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(1);
      expect(result.data[0].likes_count).toBe(0);
    });

    it('should filter by post type', async () => {
      mockSupabase.data = [];
      mockSupabase.error = null;
      mockSupabase.count = 0;

      await service.getFeed({ type: 'diy', page: 1, limit: 20 });

      expect(mockSupabase.eq).toHaveBeenCalledWith('post_type', 'diy');
    });
  });

  describe('likePost', () => {
    it('should toggle like on and return liked: true', async () => {
      mockSupabase.single
        .mockResolvedValueOnce({ data: null, error: null }) // no existing like
        .mockResolvedValueOnce({ data: { id: 'like-1' }, error: null }); // insert
      mockSupabase.rpc.mockResolvedValue({ error: null });

      const result = await service.likePost('user-1', 'post-1');

      expect(result.success).toBe(true);
      expect(result.liked).toBe(true);
    });

    it('should toggle like off and return liked: false', async () => {
      mockSupabase.single
        .mockResolvedValueOnce({ data: { id: 'like-1' }, error: null }) // existing like
        .mockResolvedValueOnce({ data: null, error: null }); // delete
      mockSupabase.rpc.mockResolvedValue({ error: null });

      const result = await service.likePost('user-1', 'post-1');

      expect(result.success).toBe(true);
      expect(result.liked).toBe(false);
    });
  });

  describe('createPost', () => {
    it('should create a post successfully', async () => {
      const mockPost = { id: 'post-1', content: 'Hello world', post_type: 'tip' };
      mockSupabase.single.mockResolvedValue({ data: mockPost, error: null });

      const result = await service.createPost('user-1', {
        post_type: 'tip',
        content: 'Hello world',
      });

      expect(result.success).toBe(true);
      expect(result.data).toEqual(mockPost);
    });
  });

  describe('addComment', () => {
    it('should add a comment successfully', async () => {
      const mockComment = { id: 'comment-1', content: 'Nice!', post_id: 'post-1' };
      mockSupabase.single.mockResolvedValue({ data: mockComment, error: null });
      mockSupabase.rpc.mockResolvedValue({ error: null });

      const result = await service.addComment('user-1', 'post-1', { content: 'Nice!' });

      expect(result.success).toBe(true);
      expect(result.data.content).toBe('Nice!');
    });
  });
});
