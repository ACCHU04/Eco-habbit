import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  UseGuards,
  Req,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
} from '@nestjs/swagger';
import { AuthGuard } from '../../common/guards/auth.guard';
import { RewardsService } from './rewards.service';

@ApiTags('Rewards')
@Controller('rewards')
export class RewardsController {
  constructor(private readonly rewardsService: RewardsService) {}

  @Post('points/award')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Award points for an action' })
  async awardPoints(
    @Req() req: any,
    @Body() body: { action: string; custom_points?: number },
  ) {
    return this.rewardsService.awardPoints(
      req.user.id,
      body.action,
      body.custom_points,
    );
  }

  @Get('points')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get total points' })
  async getTotalPoints(@Req() req: any) {
    return this.rewardsService.getTotalPoints(req.user.id);
  }

  @Get('points/history')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get points history' })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getPointsHistory(
    @Req() req: any,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.rewardsService.getPointsHistory(
      req.user.id,
      page ? parseInt(page, 10) : undefined,
      limit ? parseInt(limit, 10) : undefined,
    );
  }

  @Get('badges')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get user badges' })
  async getBadges(@Req() req: any) {
    return this.rewardsService.getBadges(req.user.id);
  }

  @Get('leaderboard')
  @ApiOperation({ summary: 'Get campus-wide leaderboard' })
  @ApiQuery({ name: 'limit', required: false })
  async getLeaderboard(@Query('limit') limit?: string) {
    return this.rewardsService.getLeaderboard(
      limit ? parseInt(limit, 10) : undefined,
    );
  }

  @Get('achievements')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get user achievements with progress' })
  async getAchievements(@Req() req: any) {
    return this.rewardsService.getAchievements(req.user.id);
  }
}
