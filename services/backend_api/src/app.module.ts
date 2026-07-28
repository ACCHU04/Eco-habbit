import { Module, NestModule, MiddlewareConsumer } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { MarketplaceModule } from './modules/marketplace/marketplace.module';
import { CommunityModule } from './modules/community/community.module';
import { AiModule } from './modules/ai/ai.module';
import { DiyModule } from './modules/diy/diy.module';
import { RewardsModule } from './modules/rewards/rewards.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { HomeModule } from './modules/home/home.module';
import { QuestsModule } from './modules/quests/quests.module';
import { CoinsModule } from './modules/coins/coins.module';
import { PassportModule } from './modules/passport/passport.module';
import { LeaderboardsModule } from './modules/leaderboards/leaderboards.module';
import { HostelsModule } from './modules/hostels/hostels.module';
import { ChallengesModule } from './modules/challenges/challenges.module';
import { SupabaseModule } from './config/supabase.module';
import { FirebaseModule } from './config/firebase.module';
import { AppCacheModule } from './common/cache/cache.module';
import { RequestIdMiddleware } from './common/middleware/request-id.middleware';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    ThrottlerModule.forRoot({
      throttlers: [
        {
          ttl: 60_000,
          limit: 60,
        },
      ],
    }),
    SupabaseModule,
    FirebaseModule,
    AppCacheModule,
    AuthModule,
    UsersModule,
    HomeModule,
    MarketplaceModule,
    CommunityModule,
    AiModule,
    DiyModule,
    RewardsModule,
    NotificationsModule,
    QuestsModule,
    CoinsModule,
    PassportModule,
    LeaderboardsModule,
    HostelsModule,
    ChallengesModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    consumer.apply(RequestIdMiddleware).forRoutes('*');
  }
}
