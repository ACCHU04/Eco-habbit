import { Controller, Get, Query, UseGuards, Request } from '@nestjs/common';
import { AuthGuard } from '../../common/guards/auth.guard';
import { PassportService } from './passport.service';

@Controller('passport')
@UseGuards(AuthGuard)
export class PassportController {
  constructor(private readonly passportService: PassportService) {}

  @Get('impact')
  async getImpact(@Request() req: any) {
    return this.passportService.getImpact(req.user.uid);
  }

  @Get('timeline')
  async getTimeline(
    @Request() req: any,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.passportService.getTimeline(
      req.user.uid,
      page ? parseInt(page, 10) : 1,
      limit ? parseInt(limit, 10) : 20,
    );
  }

  @Get('streak')
  async getStreak(@Request() req: any) {
    return this.passportService.getStreak(req.user.uid);
  }
}
