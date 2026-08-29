import {
  Controller,
  Get,
  Post,
  Param,
  Query,
  Body,
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
import { QuestsService } from './quests.service';

@ApiTags('Quests')
@Controller('quests')
export class QuestsController {
  constructor(private readonly questsService: QuestsService) {}

  @Get('today')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: "Get today's active quests with user progress" })
  async getTodayQuests(@Req() req: any) {
    return this.questsService.getTodayQuests(req.user.id);
  }

  @Get()
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get all active quests with progress' })
  async getAllQuests(@Req() req: any) {
    return this.questsService.getAllQuests(req.user.id);
  }

  @Get('history')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get completed quest history' })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getQuestHistory(
    @Req() req: any,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.questsService.getQuestHistory(
      req.user.id,
      page ? parseInt(page, 10) : undefined,
      limit ? parseInt(limit, 10) : undefined,
    );
  }

  @Post(':id/progress')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Update quest progress' })
  async updateProgress(
    @Req() req: any,
    @Param('id') questId: string,
    @Body() body: { increment?: number },
  ) {
    return this.questsService.updateQuestProgress(
      req.user.id,
      questId,
      body.increment,
    );
  }

  @Get('levels')
  @ApiOperation({ summary: 'Get XP level thresholds' })
  async getLevelThresholds() {
    return this.questsService.getLevelThresholds();
  }
}
