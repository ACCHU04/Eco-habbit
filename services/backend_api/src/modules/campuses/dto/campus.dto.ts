import { IsString, IsOptional, IsObject, MaxLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateCampusDto {
  @ApiProperty({ description: 'Display name of the campus' })
  @IsString()
  @MaxLength(200)
  name: string;

  @ApiPropertyOptional({ description: 'Short name / abbreviation' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  short_name?: string;

  @ApiPropertyOptional({ description: 'Email domain (e.g. chanakya.edu)' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  domain?: string;

  @ApiPropertyOptional({ description: 'URL to campus logo' })
  @IsOptional()
  @IsString()
  logo_url?: string;

  @ApiPropertyOptional({ description: 'City' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  city?: string;

  @ApiPropertyOptional({ description: 'State' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  state?: string;

  @ApiPropertyOptional({ description: 'Country code', default: 'IN' })
  @IsOptional()
  @IsString()
  @MaxLength(2)
  country?: string;
}

export class UpdateCampusDto {
  @ApiPropertyOptional({ description: 'Display name of the campus' })
  @IsOptional()
  @IsString()
  @MaxLength(200)
  name?: string;

  @ApiPropertyOptional({ description: 'Short name / abbreviation' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  short_name?: string;

  @ApiPropertyOptional({ description: 'Email domain' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  domain?: string;

  @ApiPropertyOptional({ description: 'URL to campus logo' })
  @IsOptional()
  @IsString()
  logo_url?: string;

  @ApiPropertyOptional({ description: 'City' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  city?: string;

  @ApiPropertyOptional({ description: 'State' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  state?: string;

  @ApiPropertyOptional({ description: 'Country code' })
  @IsOptional()
  @IsString()
  @MaxLength(2)
  country?: string;

  @ApiPropertyOptional({ description: 'Campus settings JSON' })
  @IsOptional()
  @IsObject()
  settings?: Record<string, any>;
}

export class SetCampusDto {
  @ApiProperty({ description: 'Campus slug to assign' })
  @IsString()
  slug: string;
}
