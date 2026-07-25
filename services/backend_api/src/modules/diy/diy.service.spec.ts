import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException, ConflictException } from '@nestjs/common';
import { DiyService } from './diy.service';
import { SUPABASE_CLIENT } from '../../config/supabase.module';

jest.mock('../../common/helpers/user-sync.helper', () => ({
  ensureUserExists: jest.fn().mockResolvedValue(undefined),
}));

describe('DiyService', () => {
  let service: DiyService;
  let s: any;

  beforeEach(async () => {
    s = {
      from: jest.fn().mockReturnThis(),
      select: jest.fn().mockReturnThis(),
      insert: jest.fn().mockReturnThis(),
      delete: jest.fn().mockReturnThis(),
      eq: jest.fn().mockReturnThis(),
      or: jest.fn().mockReturnThis(),
      order: jest.fn().mockReturnThis(),
      range: jest.fn().mockReturnThis(),
      single: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DiyService,
        { provide: SUPABASE_CLIENT, useValue: s },
      ],
    }).compile();

    service = module.get<DiyService>(DiyService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('getProjects', () => {
    it('returns paginated results', async () => {
      const projects = [{ id: 'p1', title: 'Project 1' }];
      s.data = projects;
      s.error = null;
      s.count = 1;

      const result = await service.getProjects({});

      expect(result.success).toBe(true);
      expect(result.data).toEqual(projects);
      expect(result.pagination).toEqual({
        page: 1,
        limit: 20,
        total: 1,
        total_pages: 1,
      });
    });

    it('applies category filter when provided', async () => {
      s.data = [];
      s.error = null;
      s.count = 0;

      await service.getProjects({ category: 'upcycling' });

      expect(s.eq).toHaveBeenCalledWith('category', 'upcycling');
    });

    it('applies difficulty filter when provided', async () => {
      s.data = [];
      s.error = null;
      s.count = 0;

      await service.getProjects({ difficulty: 'hard' });

      expect(s.eq).toHaveBeenCalledWith('difficulty', 'hard');
    });
  });

  describe('getProjectById', () => {
    it('returns project data', async () => {
      const project = { id: 'p1', title: 'Test Project' };
      s.single.mockResolvedValue({ data: project, error: null });

      const result = await service.getProjectById('p1');

      expect(result.success).toBe(true);
      expect(result.data).toEqual(project);
    });

    it('throws NotFoundException when not found', async () => {
      s.single.mockResolvedValue({ data: null, error: { message: 'not found' } });

      await expect(service.getProjectById('nonexistent')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('saveProject', () => {
    it('saves a new project successfully', async () => {
      const projectChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({ data: { id: 'p1' }, error: null }),
      };
      const savedCheckChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({ data: null, error: null }),
      };
      const insertChain = {
        from: jest.fn().mockReturnThis(),
        insert: jest.fn().mockImplementation(() =>
          Promise.resolve({ error: null }),
        ),
      };

      s.from
        .mockReturnValueOnce(projectChain)
        .mockReturnValueOnce(savedCheckChain)
        .mockReturnValueOnce(insertChain);

      const result = await service.saveProject('u1', 'p1');

      expect(result.success).toBe(true);
      expect(result.message).toBe('Project saved');
    });

    it('throws NotFoundException if project does not exist', async () => {
      const notFoundChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({ data: null, error: null }),
      };
      s.from.mockReturnValue(notFoundChain);

      await expect(service.saveProject('u1', 'nonexistent')).rejects.toThrow(
        NotFoundException,
      );
    });

    it('throws ConflictException if already saved', async () => {
      const projectChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({ data: { id: 'p1' }, error: null }),
      };
      const alreadySavedChain = {
        from: jest.fn().mockReturnThis(),
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue({
          data: { id: 'existing-save' },
          error: null,
        }),
      };
      s.from
        .mockReturnValueOnce(projectChain)
        .mockReturnValueOnce(alreadySavedChain);

      await expect(service.saveProject('u1', 'p1')).rejects.toThrow(
        ConflictException,
      );
    });
  });
});
