import { Module } from '@nestjs/common';
import { DiyController } from './diy.controller';
import { DiyService } from './diy.service';

@Module({
  controllers: [DiyController],
  providers: [DiyService],
  exports: [DiyService],
})
export class DiyModule {}
