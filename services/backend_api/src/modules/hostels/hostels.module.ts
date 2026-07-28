import { Module } from '@nestjs/common';
import { HostelsService } from './hostels.service';
import { HostelsController } from './hostels.controller';

@Module({
  controllers: [HostelsController],
  providers: [HostelsService],
  exports: [HostelsService],
})
export class HostelsModule {}
