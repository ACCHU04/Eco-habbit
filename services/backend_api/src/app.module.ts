import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { MarketplaceModule } from './modules/marketplace/marketplace.module';
import { CommunityModule } from './modules/community/community.module';
import { AiModule } from './modules/ai/ai.module';
import { DiyModule } from './modules/diy/diy.module';
import { RewardsModule } from './modules/rewards/rewards.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { HomeModule } from './modules/home/home.module';
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
  ],
})
export class AppModule {}
