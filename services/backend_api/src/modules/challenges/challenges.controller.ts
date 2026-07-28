import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
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
import { ChallengesService } from './challenges.service';

@ApiTags('Challenges')
@Controller('challenges')
export class ChallengesController {
  constructor(private readonly challengesService: ChallengesService) {}

  // ── Friends ──

  @Get('friends')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get friends list' })
  async getFriends(@Req() req: any) {
    return this.challengesService.getFriends(req.user.id);
  }

  @Post('friends/request')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Send friend request' })
  async sendFriendRequest(
    @Req() req: any,
    @Body() body: { addressee_id: string },
  ) {
    return this.challengesService.sendFriendRequest(
      req.user.id,
      body.addressee_id,
    );
  }

  @Put('friends/respond')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Accept or decline friend request' })
  async respondToFriendRequest(
    @Req() req: any,
    @Body() body: { friendship_id: string; accept: boolean },
  ) {
    return this.challengesService.respondToFriendRequest(
      req.user.id,
      body.friendship_id,
      body.accept,
    );
  }

  @Delete('friends/:friendshipId')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Remove friend' })
  async removeFriend(
    @Req() req: any,
    @Param('friendshipId') friendshipId: string,
  ) {
    return this.challengesService.removeFriend(req.user.id, friendshipId);
  }

  @Get('friends/pending')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get pending friend requests' })
  async getPendingRequests(@Req() req: any) {
    return this.challengesService.getPendingRequests(req.user.id);
  }

  // ── Challenges ──

  @Post('create')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create a friend challenge' })
  async createChallenge(
    @Req() req: any,
    @Body()
    body: {
      challengee_id: string;
      title: string;
      description: string;
      goal_action: string;
      goal_count?: number;
      duration_days?: number;
      xp_reward?: number;
      coin_reward?: number;
    },
  ) {
    return this.challengesService.createChallenge(
      req.user.id,
      body.challengee_id,
      body.title,
      body.description,
      body.goal_action,
      body.goal_count || 1,
      body.duration_days || 7,
      body.xp_reward || 100,
      body.coin_reward || 25,
    );
  }

  @Put(':id/respond')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Accept or decline a challenge' })
  async respondToChallenge(
    @Req() req: any,
    @Param('id') id: string,
    @Body() body: { accept: boolean },
  ) {
    return this.challengesService.respondToChallenge(
      req.user.id,
      id,
      body.accept,
    );
  }

  @Get('my')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get my challenges' })
  @ApiQuery({ name: 'status', required: false })
  async getMyChallenges(
    @Req() req: any,
    @Query('status') status?: string,
  ) {
    return this.challengesService.getUserChallenges(req.user.id, status);
  }

  @Get(':id')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get challenge details' })
  async getChallenge(@Param('id') id: string) {
    return this.challengesService.getChallengeById(id);
  }

  @Put(':id/progress')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update challenge progress' })
  async updateProgress(
    @Req() req: any,
    @Param('id') id: string,
    @Body() body: { increment?: number },
  ) {
    return this.challengesService.updateChallengeProgress(
      req.user.id,
      id,
      body.increment || 1,
    );
  }

  @Get('history/all')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get completed challenge history' })
  @ApiQuery({ name: 'limit', required: false })
  async getHistory(
    @Req() req: any,
    @Query('limit') limit?: string,
  ) {
    return this.challengesService.getChallengeHistory(
      req.user.id,
      limit ? parseInt(limit, 10) : undefined,
    );
  }
}
