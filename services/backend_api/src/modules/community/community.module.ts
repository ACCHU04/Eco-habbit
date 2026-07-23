import { Module } from '@nestjs/common';
import { CommunityService } from './community.service';
import {
  CommunityController,
  ReportsController,
  AdminController,
} from './community.controller';

@Module({
  controllers: [CommunityController, ReportsController, AdminController],
  providers: [CommunityService],
  exports: [CommunityService],
})
export class CommunityModule {}
