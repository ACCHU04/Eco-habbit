import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  Query,
  Body,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AuthGuard } from '../../common/guards/auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { DiyService } from './diy.service';
import { DiyQueryDto, SaveProjectDto } from './dto/diy.dto';

@ApiTags('DIY Studio')
@Controller('diy')
export class DiyController {
  constructor(private readonly diyService: DiyService) {}

  @Get('projects')
  @ApiOperation({ summary: 'List DIY projects (filterable)' })
  async getProjects(@Query() query: DiyQueryDto) {
    return this.diyService.getProjects(query);
  }

  @Get('projects/:id')
  @ApiOperation({ summary: 'Get project details' })
  async getProject(@Param('id') id: string) {
    return this.diyService.getProjectById(id);
  }

  @Post('saved')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Save a project for later' })
  async saveProject(
    @CurrentUser('id') userId: string,
    @Body() dto: SaveProjectDto,
  ) {
    return this.diyService.saveProject(userId, dto.project_id);
  }

  @Get('saved')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get saved projects' })
  async getSavedProjects(@CurrentUser('id') userId: string) {
    return this.diyService.getSavedProjects(userId);
  }

  @Delete('saved/:projectId')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Remove saved project' })
  async unsaveProject(
    @CurrentUser('id') userId: string,
    @Param('projectId') projectId: string,
  ) {
    return this.diyService.unsaveProject(userId, projectId);
  }
}
