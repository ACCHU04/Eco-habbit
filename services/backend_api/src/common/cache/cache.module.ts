import { Module, Global } from '@nestjs/common';
import { CacheModule } from '@nestjs/cache-manager';
import { AppCacheService } from './cache.service';

@Global()
@Module({
  imports: [
    CacheModule.register({
      ttl: 60_000,
      max: 500,
    }),
  ],
  providers: [AppCacheService],
  exports: [CacheModule, AppCacheService],
})
export class AppCacheModule {}
