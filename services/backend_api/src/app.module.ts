import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
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

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    SupabaseModule,
    FirebaseModule,
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
  providers: [AppService],
})
export class AppModule {}
