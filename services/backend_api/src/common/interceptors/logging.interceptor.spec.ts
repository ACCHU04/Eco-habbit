import { TestingModule, Test } from '@nestjs/testing';
import { ExecutionContext, CallHandler } from '@nestjs/common';
import { of } from 'rxjs';
import { LoggingInterceptor } from './logging.interceptor';

describe('LoggingInterceptor', () => {
  let interceptor: LoggingInterceptor;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [LoggingInterceptor],
    }).compile();

    interceptor = module.get<LoggingInterceptor>(LoggingInterceptor);
  });

  function createMockContext(overrides: Record<string, unknown> = {}) {
    const request = {
      method: 'GET',
      url: '/api/v1/users',
      requestId: 'req-123',
      user: { id: 'user-456' },
      ...overrides,
    };
    const response = { statusCode: 200 };
    return {
      switchToHttp: () => ({
        getRequest: () => request,
        getResponse: () => response,
      }),
    } as unknown as ExecutionContext;
  }

  function createCallHandler(): CallHandler {
    return { handle: () => of({ success: true }) } as CallHandler;
  }

  it('should be defined', () => {
    expect(interceptor).toBeDefined();
  });

  it('logs method, url, status code, and latency', (done) => {
    const logSpy = jest.spyOn(
      (interceptor as any).logger,
      'log',
    );

    const context = createMockContext();
    const next = createCallHandler();

    interceptor.intercept(context, next).subscribe(() => {
      expect(logSpy).toHaveBeenCalled();
      const logMessage = logSpy.mock.calls[0][0] as string;
      expect(logMessage).toContain('GET');
      expect(logMessage).toContain('/api/v1/users');
      expect(logMessage).toContain('200');
      expect(logMessage).toContain('ms');
      done();
    });
  });

  it('includes request ID from middleware', (done) => {
    const logSpy = jest.spyOn(
      (interceptor as any).logger,
      'log',
    );

    const context = createMockContext({ requestId: 'abc-def-123' });
    const next = createCallHandler();

    interceptor.intercept(context, next).subscribe(() => {
      const logMessage = logSpy.mock.calls[0][0] as string;
      expect(logMessage).toContain('[abc-def-123]');
      done();
    });
  });

  it('shows anonymous when no user authenticated', (done) => {
    const logSpy = jest.spyOn(
      (interceptor as any).logger,
      'log',
    );

    const context = createMockContext({ user: undefined });
    const next = createCallHandler();

    interceptor.intercept(context, next).subscribe(() => {
      const logMessage = logSpy.mock.calls[0][0] as string;
      expect(logMessage).toContain('[anonymous]');
      done();
    });
  });

  it('shows user ID when authenticated', (done) => {
    const logSpy = jest.spyOn(
      (interceptor as any).logger,
      'log',
    );

    const context = createMockContext({ user: { id: 'uid-789' } });
    const next = createCallHandler();

    interceptor.intercept(context, next).subscribe(() => {
      const logMessage = logSpy.mock.calls[0][0] as string;
      expect(logMessage).toContain('[uid-789]');
      done();
    });
  });

  it('handles missing requestId gracefully', (done) => {
    const logSpy = jest.spyOn(
      (interceptor as any).logger,
      'log',
    );

    const context = createMockContext({ requestId: undefined });
    const next = createCallHandler();

    interceptor.intercept(context, next).subscribe(() => {
      const logMessage = logSpy.mock.calls[0][0] as string;
      expect(logMessage).toContain('[-]');
      done();
    });
  });
});
