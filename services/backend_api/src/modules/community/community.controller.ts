import {
  Controller,
  Get,
  Post,
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
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { CommunityService } from './community.service';
import {
  CreatePostDto,
  CreateCommentDto,
  CreateReportDto,
  ResolveReportDto,
} from './dto/community.dto';

@ApiTags('Community')
@Controller('community')
export class CommunityController {
  constructor(private readonly communityService: CommunityService) {}

  @Post('posts')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create a community post' })
  async createPost(@Req() req: any, @Body() dto: CreatePostDto) {
    return this.communityService.createPost(req.user.id, dto);
  }

  @Get('posts')
  @ApiOperation({ summary: 'Get community feed' })
  @ApiQuery({
    name: 'type',
    required: false,
    enum: ['diy', 'tip', 'marketplace'],
  })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getFeed(
    @Query('type') type?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.communityService.getFeed({
      type,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });
  }

  @Get('posts/:id')
  @ApiOperation({ summary: 'Get post details with comments' })
  async getPostById(@Param('id') id: string) {
    return this.communityService.getPostById(id);
  }

  @Post('posts/:id/like')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Like/unlike a post' })
  async likePost(@Req() req: any, @Param('id') id: string) {
    return this.communityService.likePost(req.user.id, id);
  }

  @Post('posts/:id/comments')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Add comment to a post' })
  async addComment(
    @Req() req: any,
    @Param('id') id: string,
    @Body() dto: CreateCommentDto,
  ) {
    return this.communityService.addComment(req.user.id, id, dto);
  }

  @Delete('posts/:id')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete own post' })
  async deletePost(@Req() req: any, @Param('id') id: string) {
    return this.communityService.deletePost(id, req.user.id);
  }
}

@ApiTags('Reports')
@Controller('reports')
export class ReportsController {
  constructor(private readonly communityService: CommunityService) {}

  @Post()
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Report content' })
  async createReport(@Req() req: any, @Body() dto: CreateReportDto) {
    return this.communityService.createReport(req.user.id, dto);
  }
}

@ApiTags('Admin')
@Controller('admin')
@UseGuards(AuthGuard, RolesGuard)
@Roles('admin')
export class AdminController {
  constructor(private readonly communityService: CommunityService) {}

  @Get('reports')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get reported content queue' })
  @ApiQuery({ name: 'status', required: false })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getReports(
    @Query('status') status?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.communityService.getReports({
      status,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });
  }

  @Post('reports/:id/resolve')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Resolve a report' })
  async resolveReport(
    @Req() req: any,
    @Param('id') id: string,
    @Body() dto: ResolveReportDto,
  ) {
    return this.communityService.resolveReport(id, req.user.id, dto);
  }
}
