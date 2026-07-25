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
      ilike: jest.fn().mockReturnThis(),
      limit: jest.fn().mockReturnThis(),
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
        .mockResolvedValueOnce({ data: { id: 'like-1' }, error: null }) // insert
        .mockResolvedValueOnce({ data: { author_id: 'post-author' }, error: null }) // post lookup
        .mockResolvedValueOnce({ data: { full_name: 'Liker' }, error: null }) // liker lookup
        .mockResolvedValueOnce({ data: { id: 'notif-1' }, error: null }); // notification
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

    it('should not notify when liking own post', async () => {
      mockSupabase.single
        .mockResolvedValueOnce({ data: null, error: null }) // no existing like
        .mockResolvedValueOnce({ data: { id: 'like-1' }, error: null }) // insert
        .mockResolvedValueOnce({ data: { author_id: 'user-1' }, error: null }); // same author
      mockSupabase.rpc.mockResolvedValue({ error: null });

      const result = await service.likePost('user-1', 'post-1');

      expect(result.success).toBe(true);
      expect(result.liked).toBe(true);
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
      mockSupabase.single
        .mockResolvedValueOnce({ data: { author_id: 'user-1' }, error: null }) // post lookup
        .mockResolvedValueOnce({ data: { full_name: 'Commenter' }, error: null }) // commenter name
        .mockResolvedValueOnce({ data: mockComment, error: null }) // insert comment
        .mockResolvedValueOnce({ data: { id: 'notif-1' }, error: null }); // notification
      mockSupabase.rpc.mockResolvedValue({ error: null });

      const result = await service.addComment('user-1', 'post-1', { content: 'Nice!' });

      expect(result.success).toBe(true);
      expect(result.data.content).toBe('Nice!');
    });

    it('should not notify when commenting on own post', async () => {
      const mockComment = { id: 'comment-1', content: 'Self!', post_id: 'post-1' };
      mockSupabase.single
        .mockResolvedValueOnce({ data: { author_id: 'user-1' }, error: null }) // same author
        .mockResolvedValueOnce({ data: { full_name: 'Self' }, error: null })
        .mockResolvedValueOnce({ data: mockComment, error: null });
      mockSupabase.rpc.mockResolvedValue({ error: null });

      const result = await service.addComment('user-1', 'post-1', { content: 'Self!' });

      expect(result.success).toBe(true);
    });
  });

  describe('deleteComment', () => {
    it('should delete own comment successfully', async () => {
      mockSupabase.single
        .mockResolvedValueOnce({ data: { id: 'c1', author_id: 'user-1' }, error: null })
        .mockResolvedValueOnce({ data: { author_id: 'user-1' }, error: null });
      mockSupabase.delete = jest.fn().mockReturnThis();
      mockSupabase.rpc.mockResolvedValue({ error: null });

      const result = await service.deleteComment('c1', 'post-1', 'user-1');

      expect(result.success).toBe(true);
      expect(result.message).toBe('Comment deleted');
    });

    it('should delete comment as post owner', async () => {
      mockSupabase.single
        .mockResolvedValueOnce({ data: { id: 'c1', author_id: 'other-user' }, error: null })
        .mockResolvedValueOnce({ data: { author_id: 'user-1' }, error: null });
      mockSupabase.delete = jest.fn().mockReturnThis();
      mockSupabase.rpc.mockResolvedValue({ error: null });

      const result = await service.deleteComment('c1', 'post-1', 'user-1');

      expect(result.success).toBe(true);
    });

    it('should throw ForbiddenException when not authorized', async () => {
      mockSupabase.single
        .mockResolvedValueOnce({ data: { id: 'c1', author_id: 'other-user' }, error: null })
        .mockResolvedValueOnce({ data: { author_id: 'another-user' }, error: null });

      await expect(
        service.deleteComment('c1', 'post-1', 'user-1'),
      ).rejects.toThrow('Not authorized');
    });

    it('should throw NotFoundException for missing comment', async () => {
      mockSupabase.single.mockResolvedValue({ data: null, error: null });

      await expect(
        service.deleteComment('c1', 'post-1', 'user-1'),
      ).rejects.toThrow('Comment not found');
    });
  });

  describe('getFeed error handling', () => {
    it('should propagate errors from Supabase', async () => {
      mockSupabase.data = null;
      mockSupabase.error = { message: 'Connection refused' };
      mockSupabase.count = null;

      await expect(
        service.getFeed({ page: 1, limit: 20 }),
      ).rejects.toThrow('Connection refused');
    });
  });

  describe('toggleBookmark', () => {
    it('should add a bookmark when none exists', async () => {
      mockSupabase.single
        .mockResolvedValueOnce({ data: null, error: null }) // no existing bookmark
        .mockResolvedValueOnce({ data: { id: 'bm-1' }, error: null }); // insert

      const result = await service.toggleBookmark('user-1', 'post-1');

      expect(result.success).toBe(true);
      expect(result.bookmarked).toBe(true);
    });

    it('should remove a bookmark when one exists', async () => {
      mockSupabase.single
        .mockResolvedValueOnce({ data: { id: 'bm-1' }, error: null }) // existing
        .mockResolvedValueOnce({ data: null, error: null }); // delete
      mockSupabase.delete = jest.fn().mockReturnThis();

      const result = await service.toggleBookmark('user-1', 'post-1');

      expect(result.success).toBe(true);
      expect(result.bookmarked).toBe(false);
    });

    it('should throw on insert error', async () => {
      mockSupabase.single.mockResolvedValue({ data: null, error: null });
      mockSupabase.insert.mockResolvedValue({ data: null, error: { message: 'Insert failed' } });

      await expect(service.toggleBookmark('user-1', 'post-1')).rejects.toThrow('Insert failed');
    });
  });

  describe('searchPosts', () => {
    it('should search posts by content', async () => {
      mockSupabase.data = [
        { id: '1', content: 'Recycling tips for plastics', post_type: 'tip' },
      ];
      mockSupabase.error = null;
      mockSupabase.count = 1;

      const result = await service.searchPosts({ q: 'recycling' });

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(1);
    });

    it('should reject queries shorter than 2 characters', async () => {
      await expect(service.searchPosts({ q: 'a' })).rejects.toThrow('at least 2 characters');
    });

    it('should filter by post type when provided', async () => {
      mockSupabase.data = [];
      mockSupabase.error = null;
      mockSupabase.count = 0;

      await service.searchPosts({ q: 'recycling', type: 'diy' });

      expect(mockSupabase.eq).toHaveBeenCalledWith('post_type', 'diy');
    });
  });

  describe('getTrending', () => {
    it('should return trending posts from RPC', async () => {
      mockSupabase.rpc.mockResolvedValue({
        data: [{ id: '1', content: 'Popular post' }],
        error: null,
      });

      const result = await service.getTrending({ limit: 10 });

      expect(result.success).toBe(true);
      expect(result.data).toHaveLength(1);
    });

    it('should fall back to likes_count when RPC fails', async () => {
      mockSupabase.rpc.mockResolvedValue({ data: null, error: { message: 'function not found' } });
      mockSupabase.data = [{ id: '1', content: 'Most liked' }];
      mockSupabase.error = null;

      const result = await service.getTrending({ limit: 5 });

      expect(result.success).toBe(true);
      expect(mockSupabase.order).toHaveBeenCalledWith('likes_count', { ascending: false });
    });
  });

  describe('uploadImage', () => {
    it('should upload a valid image successfully', async () => {
      const mockFile = {
        buffer: Buffer.from('fake-image'),
        mimetype: 'image/jpeg',
        size: 1024,
        originalname: 'photo.jpg',
      } as Express.Multer.File;

      mockSupabase.storage = {
        from: jest.fn().mockReturnValue({
          upload: jest.fn().mockResolvedValue({ data: { path: 'u1/file.jpg' }, error: null }),
          getPublicUrl: jest.fn().mockReturnValue({ data: { publicUrl: 'https://storage.example.com/u1/file.jpg' } }),
        }),
      };

      const result = await service.uploadImage('user-1', mockFile);

      expect(result.success).toBe(true);
      expect(result.url).toBe('https://storage.example.com/u1/file.jpg');
    });

    it('should reject when no file provided', async () => {
      await expect(service.uploadImage('user-1', null as any)).rejects.toThrow('No file provided');
    });

    it('should reject non-image mimetypes', async () => {
      const mockFile = {
        buffer: Buffer.from('not-an-image'),
        mimetype: 'application/pdf',
        size: 1024,
        originalname: 'file.pdf',
      } as Express.Multer.File;

      await expect(service.uploadImage('user-1', mockFile)).rejects.toThrow('Only JPEG');
    });

    it('should reject files over 5MB', async () => {
      const mockFile = {
        buffer: Buffer.alloc(6 * 1024 * 1024),
        mimetype: 'image/png',
        size: 6 * 1024 * 1024,
        originalname: 'big.png',
      } as Express.Multer.File;

      await expect(service.uploadImage('user-1', mockFile)).rejects.toThrow('smaller than 5MB');
    });

    it('should handle storage upload errors', async () => {
      const mockFile = {
        buffer: Buffer.from('fake-image'),
        mimetype: 'image/webp',
        size: 512,
        originalname: 'photo.webp',
      } as Express.Multer.File;

      mockSupabase.storage = {
        from: jest.fn().mockReturnValue({
          upload: jest.fn().mockResolvedValue({ data: null, error: { message: 'Bucket not found' } }),
          getPublicUrl: jest.fn(),
        }),
      };

      await expect(service.uploadImage('user-1', mockFile)).rejects.toThrow('Bucket not found');
    });
  });
});
