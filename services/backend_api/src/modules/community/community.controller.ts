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
  UseInterceptors,
  UploadedFile,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
  ApiConsumes,
  ApiBody,
} from '@nestjs/swagger';
import { AuthGuard } from '../../common/guards/auth.guard';
import { CommunityService } from './community.service';
import {
  CreatePostDto,
  CreateCommentDto,
  CreateReportDto,
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

  @Post('posts/:id/bookmark')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Toggle bookmark on a post' })
  async toggleBookmark(@Req() req: any, @Param('id') id: string) {
    return this.communityService.toggleBookmark(req.user.id, id);
  }

  @Get('bookmarks')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get bookmarked posts' })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getBookmarks(
    @Req() req: any,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.communityService.getBookmarks(
      req.user.id,
      page ? parseInt(page, 10) : undefined,
      limit ? parseInt(limit, 10) : undefined,
    );
  }

  @Post('upload-image')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @UseInterceptors(FileInterceptor('file'))
  @ApiOperation({ summary: 'Upload an image for a post' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: { type: 'string', format: 'binary' },
      },
    },
  })
  async uploadImage(@Req() req: any, @UploadedFile() file: Express.Multer.File) {
    return this.communityService.uploadImage(req.user.id, file);
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

  @Get('posts/search')
  @ApiOperation({ summary: 'Search posts by content' })
  @ApiQuery({ name: 'q', required: true })
  @ApiQuery({ name: 'type', required: false })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async searchPosts(
    @Query('q') q: string,
    @Query('type') type?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.communityService.searchPosts({
      q,
      type,
      page: page ? parseInt(page, 10) : undefined,
      limit: limit ? parseInt(limit, 10) : undefined,
    });
  }

  @Get('posts/trending')
  @ApiOperation({ summary: 'Get trending posts' })
  @ApiQuery({ name: 'limit', required: false })
  async getTrending(@Query('limit') limit?: string) {
    return this.communityService.getTrending({
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

  @Delete('posts/:postId/comments/:commentId')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Delete a comment (author or post owner)' })
  async deleteComment(
    @Req() req: any,
    @Param('postId') postId: string,
    @Param('commentId') commentId: string,
  ) {
    return this.communityService.deleteComment(commentId, postId, req.user.id);
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
