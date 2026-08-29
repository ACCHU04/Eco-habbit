import {
  Controller,
  Get,
  Query,
  Param,
  UseGuards,
  Req,
  UseInterceptors,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
} from '@nestjs/swagger';
import { CacheInterceptor, CacheTTL as CCacheTTL } from '@nestjs/cache-manager';
import { AuthGuard } from '../../common/guards/auth.guard';
import { LeaderboardsService } from './leaderboards.service';
import {
  AppCacheService,
  CacheKeys,
  CacheTTL,
} from '../../common/cache/cache.service';

@ApiTags('Leaderboards')
@Controller('leaderboards')
export class LeaderboardsController {
  constructor(
    private readonly leaderboardsService: LeaderboardsService,
    private readonly cacheService: AppCacheService,
  ) {}

  @Get()
  @UseInterceptors(CacheInterceptor)
  @CCacheTTL(30)
  @ApiOperation({ summary: 'Get filtered leaderboard (campus/college/hostel/department)' })
  @ApiQuery({ name: 'filter', required: false, enum: ['campus', 'college', 'hostel', 'department'] })
  @ApiQuery({ name: 'value', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getLeaderboard(
    @Query('filter') filter?: string,
    @Query('value') value?: string,
    @Query('limit') limit?: string,
  ) {
    const cacheKey = CacheKeys.leaderboard.filtered(
      filter || 'campus',
      value || '',
    );
    const cached = await this.cacheService.get<any>(cacheKey);
    if (cached) return cached;

    const result = await this.leaderboardsService.getFilteredLeaderboard(
      filter || 'campus',
      value,
      limit ? parseInt(limit, 10) : undefined,
    );
    await this.cacheService.set(cacheKey, result, CacheTTL.LEADERBOARD);
    return result;
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
    const cacheKey = CacheKeys.leaderboard.friend(req.user.id);
    const cached = await this.cacheService.get<any>(cacheKey);
    if (cached) return cached;

    const result = await this.leaderboardsService.getFriendLeaderboard(
      req.user.id,
      limit ? parseInt(limit, 10) : undefined,
    );
    await this.cacheService.set(cacheKey, result, CacheTTL.LEADERBOARD);
    return result;
  }

  @Get('hostels')
  @UseInterceptors(CacheInterceptor)
  @CCacheTTL(30)
  @ApiOperation({ summary: 'Get hostel leaderboard' })
  @ApiQuery({ name: 'college', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getHostelLeaderboard(
    @Query('college') college?: string,
    @Query('limit') limit?: string,
  ) {
    const cacheKey = CacheKeys.leaderboard.hostel(college || '');
    const cached = await this.cacheService.get<any>(cacheKey);
    if (cached) return cached;

    const result = await this.leaderboardsService.getHostelLeaderboard(
      college,
      limit ? parseInt(limit, 10) : undefined,
    );
    await this.cacheService.set(cacheKey, result, CacheTTL.LEADERBOARD);
    return result;
  }

  @Get('period/:period')
  @UseInterceptors(CacheInterceptor)
  @CCacheTTL(30)
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
    const cacheKey = CacheKeys.leaderboard.period(
      period,
      filter || 'campus',
      value || '',
    );
    const cached = await this.cacheService.get<any>(cacheKey);
    if (cached) return cached;

    const result = await this.leaderboardsService.getPeriodLeaderboard(
      period,
      filter || 'campus',
      value,
      limit ? parseInt(limit, 10) : undefined,
    );
    await this.cacheService.set(cacheKey, result, CacheTTL.LEADERBOARD);
    return result;
  }

  @Get('me')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get current user rank' })
  async getMyRank(@Req() req: any) {
    return this.leaderboardsService.getUserRank(req.user.id);
  }
}
