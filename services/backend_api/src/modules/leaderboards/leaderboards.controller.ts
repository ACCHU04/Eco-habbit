import {
  Controller,
  Get,
  Query,
  Param,
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
import { LeaderboardsService } from './leaderboards.service';

@ApiTags('Leaderboards')
@Controller('leaderboards')
export class LeaderboardsController {
  constructor(private readonly leaderboardsService: LeaderboardsService) {}

  @Get()
  @ApiOperation({ summary: 'Get filtered leaderboard (campus/college/hostel/department)' })
  @ApiQuery({ name: 'filter', required: false, enum: ['campus', 'college', 'hostel', 'department'] })
  @ApiQuery({ name: 'value', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getLeaderboard(
    @Query('filter') filter?: string,
    @Query('value') value?: string,
    @Query('limit') limit?: string,
  ) {
    return this.leaderboardsService.getFilteredLeaderboard(
      filter || 'campus',
      value,
      limit ? parseInt(limit, 10) : undefined,
    );
  }

  @Get('friends')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get friends leaderboard' })
  @ApiQuery({ name: 'limit', required: false })
  async getFriendLeaderboard(
    @Req() req: any,
    @Query('limit') limit?: string,
  ) {
    return this.leaderboardsService.getFriendLeaderboard(
      req.user.id,
      limit ? parseInt(limit, 10) : undefined,
    );
  }

  @Get('hostels')
  @ApiOperation({ summary: 'Get hostel leaderboard' })
  @ApiQuery({ name: 'college', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getHostelLeaderboard(
    @Query('college') college?: string,
    @Query('limit') limit?: string,
  ) {
    return this.leaderboardsService.getHostelLeaderboard(
      college,
      limit ? parseInt(limit, 10) : undefined,
    );
  }

  @Get('period/:period')
  @ApiOperation({ summary: 'Get leaderboard by time period' })
  @ApiQuery({ name: 'filter', required: false })
  @ApiQuery({ name: 'value', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getPeriodLeaderboard(
    @Param('period') period: string,
    @Query('filter') filter?: string,
    @Query('value') value?: string,
    @Query('limit') limit?: string,
  ) {
    return this.leaderboardsService.getPeriodLeaderboard(
      period,
      filter || 'campus',
      value,
      limit ? parseInt(limit, 10) : undefined,
    );
  }

  @Get('me')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get current user rank' })
  async getMyRank(@Req() req: any) {
    return this.leaderboardsService.getUserRank(req.user.id);
  }
}
