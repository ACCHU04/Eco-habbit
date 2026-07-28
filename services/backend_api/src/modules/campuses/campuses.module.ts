import { Module } from '@nestjs/common';
import { CampusesService } from './campuses.service';
import { CampusesController, UserCampusController } from './campuses.controller';

@Module({
  controllers: [CampusesController, UserCampusController],
  providers: [CampusesService],
  exports: [CampusesService],
})
export class CampusesModule {}
