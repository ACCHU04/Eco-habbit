import { Module } from '@nestjs/common';
import { CommunityService } from './community.service';
import { CommunityController, ReportsController } from './community.controller';

@Module({
  controllers: [CommunityController, ReportsController],
  providers: [CommunityService],
  exports: [CommunityService],
})
export class CommunityModule {}
