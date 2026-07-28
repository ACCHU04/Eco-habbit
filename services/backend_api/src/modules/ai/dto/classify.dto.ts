import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsOptional } from 'class-validator';

export class ClassifyDto {
  @ApiPropertyOptional({
    description: 'Image URL (alternative to file upload)',
  })
  @IsOptional()
  @IsString()
  image_url?: string;
}

export interface LabelInfo {
  label: string;
  confidence: number;
}

export interface ClassificationResult {
  category: string;
  confidence: number;
  disposal_tips: string;
  is_uncertain: boolean;
  explanation: string;
  top_labels: LabelInfo[];
}

export interface DiySuggestion {
  project_id: string;
  title: string;
  difficulty: string;
  estimated_time: string;
  estimated_price: number;
  materials: string[];
  thumbnail_url: string | null;
}

export interface ClassifyResponse {
  result: ClassificationResult;
  diy_suggestions: DiySuggestion[];
  cached: boolean;
}
