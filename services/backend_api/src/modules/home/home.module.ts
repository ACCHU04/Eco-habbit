import { Module } from '@nestjs/common';
import { HomeController } from './home.controller';
import { HomeService } from './home.service';
import { UsersModule } from '../users/users.module';
import { MarketplaceModule } from '../marketplace/marketplace.module';

@Module({
  imports: [UsersModule, MarketplaceModule],
  controllers: [HomeController],
  providers: [HomeService],
})
export class HomeModule {}
