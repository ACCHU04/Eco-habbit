import {
  Controller,
  Post,
  Get,
  UseGuards,
  UseInterceptors,
  UploadedFile,
  Query,
  Param,
  Body,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiConsumes,
  ApiBody,
} from '@nestjs/swagger';
import { AuthGuard } from '../../common/guards/auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { AiService } from './ai.service';
import { ClassifyDto } from './dto/classify.dto';

@ApiTags('AI Scanner')
@Controller('ai')
export class AiController {
  constructor(private readonly aiService: AiService) {}

  @Post('classify')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @UseInterceptors(FileInterceptor('file'))
  @ApiOperation({ summary: 'Classify waste image' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
          description: 'Image file (JPEG/PNG, max 5MB)',
        },
        image_url: {
          type: 'string',
          description: 'Image URL (alternative to file upload)',
        },
      },
    },
  })
  async classify(
    @CurrentUser('id') userId: string,
    @UploadedFile() file?: Express.Multer.File,
    @Body() dto?: ClassifyDto,
  ) {
    if (file) {
      return this.aiService.classifyImage(
        userId,
        file.buffer,
        file.originalname,
      );
    }
    if (dto?.image_url) {
      return this.aiService.classifyImageByUrl(userId, dto.image_url);
    }
    throw new BadRequestException('Provide either file or image_url');
  }

  @Get('scans')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Get user scan history' })
  async getScanHistory(
    @CurrentUser('id') userId: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.aiService.getScanHistory(
      userId,
      page ? Number(page) : 1,
      limit ? Number(limit) : 20,
    );
  }

  @Get('cache/:hash')
  @ApiOperation({ summary: 'Check cache for image hash' })
  async checkCache(@Param('hash') hash: string) {
    const cached = await this.aiService.checkCache(hash);
    if (!cached) return { cached: false };
    return { cached: true, ...cached };
  }
}
