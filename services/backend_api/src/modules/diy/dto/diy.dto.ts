import { IsString, IsOptional, IsEnum } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class DiyQueryDto {
  @ApiPropertyOptional({ description: 'Filter by category' })
  @IsOptional()
  @IsString()
  category?: string;

  @ApiPropertyOptional({
    enum: ['easy', 'medium', 'hard'],
    description: 'Filter by difficulty',
  })
  @IsOptional()
  @IsEnum(['easy', 'medium', 'hard'] as const)
  difficulty?: string;

  @ApiPropertyOptional({ description: 'Search by title or description' })
  @IsOptional()
  @IsString()
  search?: string;

  @ApiPropertyOptional({ description: 'Page number' })
  @IsOptional()
  page?: string;

  @ApiPropertyOptional({ description: 'Items per page' })
  @IsOptional()
  limit?: string;
}

export class SaveProjectDto {
  @ApiPropertyOptional({ description: 'Project ID to save' })
  @IsString()
  project_id: string;
}
