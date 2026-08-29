import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import request from 'supertest';
import { NotificationsController } from './notifications.controller';
import { NotificationsService } from './notifications.service';

jest.mock('../../common/guards/auth.guard', () => {
  return {
    AuthGuard: jest.fn().mockImplementation(() => ({
      canActivate: (context: any) => {
        const req = context.switchToHttp().getRequest();
        req.user = { id: 'user-1', email: 'test@example.com' };
        return true;
      },
    })),
  };
});

describe('NotificationsController (e2e)', () => {
  let app: INestApplication;
  let mockService: Record<string, jest.Mock>;

  beforeAll(async () => {
    mockService = {
      createNotification: jest.fn().mockResolvedValue({
        success: true,
        data: { id: 'notif-1', type: 'like_comment', title: 'Test', body: 'Body' },
      }),
      getNotifications: jest.fn().mockResolvedValue({
        success: true,
        data: [],
        pagination: { page: 1, limit: 20, total: 0, total_pages: 0 },
      }),
      getUnreadCount: jest.fn().mockResolvedValue({ success: true, unread_count: 0 }),
      markAsRead: jest.fn().mockResolvedValue({ success: true }),
      markAllAsRead: jest.fn().mockResolvedValue({ success: true }),
      getPreferences: jest.fn().mockResolvedValue({ success: true, data: {} }),
      updatePreferences: jest.fn().mockResolvedValue({ success: true, data: {} }),
    };

    const module: TestingModule = await Test.createTestingModule({
      controllers: [NotificationsController],
      providers: [
        { provide: NotificationsService, useValue: mockService },
      ],
    }).compile();

    app = module.createNestApplication();
    app.setGlobalPrefix('api/v1');
    app.useGlobalPipes(
      new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true }),
    );
    await app.init();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('POST /api/v1/notifications', () => {
    it('should create a notification (authenticated)', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/notifications')
        .send({
          type: 'like_comment',
          title: 'New like',
          body: 'Someone liked your post',
        });

      expect(response.status).toBe(201);
      expect(response.body.success).toBe(true);
      expect(mockService.createNotification).toHaveBeenCalledWith(
        'user-1', 'like_comment', 'New like', 'Someone liked your post', undefined,
      );
    });

    it('should return 400 for malformed DTO (invalid type)', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/notifications')
        .send({
          type: 'invalid_type',
          title: 'Test',
          body: 'Body',
        });

      expect(response.status).toBe(400);
    });

    it('should return 400 for missing required fields', async () => {
      const response = await request(app.getHttpServer())
        .post('/api/v1/notifications')
        .send({
          type: 'like_comment',
        });

      expect(response.status).toBe(400);
    });
  });
});
