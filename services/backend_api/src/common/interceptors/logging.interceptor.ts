import { Injectable, NestInterceptor, ExecutionContext, CallHandler, Logger } from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger('HTTP');

  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const request = context.switchToHttp().getRequest();
    const { method, url } = request;
    const requestId = (request as any)['requestId'] || '-';
    const userId = (request as any).user?.id || 'anonymous';
    const startTime = Date.now();

    return next.handle().pipe(
      tap(() => {
        const response = context.switchToHttp().getResponse();
        const latency = Date.now() - startTime;
        const statusCode = response.statusCode;
        this.logger.log(
          `[${requestId}] [${userId}] ${method} ${url} ${statusCode} ${latency}ms`,
        );
      }),
    );
  }
}
