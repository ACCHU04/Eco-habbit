import {
  IsString,
  IsNumber,
  IsEnum,
  IsOptional,
  Min,
  MaxLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum ProductCategory {
  textbooks_stationery = 'textbooks_stationery',
  electronics_gadgets = 'electronics_gadgets',
  furniture_decor = 'furniture_decor',
  clothing_accessories = 'clothing_accessories',
  sports_fitness = 'sports_fitness',
  others = 'others',
}

export enum ProductCondition {
  new = 'new',
  good = 'good',
  fair = 'fair',
  used = 'used',
}

export class CreateListingDto {
  @ApiProperty({ example: 'Calculus Textbook' })
  @IsString()
  @MaxLength(200)
  title: string;

  @ApiProperty({ example: 'Thomas Calculus 14th edition, barely used' })
  @IsString()
  description: string;

  @ApiProperty({ example: 250 })
  @IsNumber()
  @Min(0)
  price: number;

  @ApiProperty({
    enum: ProductCategory,
    example: ProductCategory.textbooks_stationery,
  })
  @IsEnum(ProductCategory)
  category: ProductCategory;

  @ApiProperty({ enum: ProductCondition, example: ProductCondition.good })
  @IsEnum(ProductCondition)
  condition: ProductCondition;

  @ApiPropertyOptional({
    type: [String],
    example: ['https://example.com/img1.jpg'],
  })
  @IsOptional()
  @IsString({ each: true })
  image_urls?: string[];
}

export class UpdateListingDto {
  @ApiPropertyOptional({ example: 'Updated Title' })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  title?: string;

  @ApiPropertyOptional({ example: 'Updated description' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiPropertyOptional({ example: 200 })
  @IsOptional()
  @IsNumber()
  @Min(0)
  price?: number;

  @ApiPropertyOptional({ enum: ProductCategory })
  @IsOptional()
  @IsEnum(ProductCategory)
  category?: ProductCategory;

  @ApiPropertyOptional({ enum: ProductCondition })
  @IsOptional()
  @IsEnum(ProductCondition)
  condition?: ProductCondition;

  @ApiPropertyOptional({ enum: ['active', 'sold', 'removed'] })
  @IsOptional()
  @IsString()
  status?: string;
}
