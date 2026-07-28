import { IsString, IsOptional, IsEnum } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdateUserDto {
  @ApiPropertyOptional({ example: 'John Doe' })
  @IsString()
  @IsOptional()
  full_name?: string;

  @ApiPropertyOptional({ example: 'IIT Delhi' })
  @IsString()
  @IsOptional()
  college?: string;

  @ApiPropertyOptional({ example: 'https://example.com/photo.jpg' })
  @IsString()
  @IsOptional()
  profile_photo?: string;

  @ApiPropertyOptional({ example: 'Love sustainability!' })
  @IsString()
  @IsOptional()
  bio?: string;

  @ApiPropertyOptional({ example: 'Block A' })
  @IsString()
  @IsOptional()
  hostel?: string;

  @ApiPropertyOptional({ example: 'Computer Science' })
  @IsString()
  @IsOptional()
  department?: string;

  @ApiPropertyOptional({ enum: ['student', 'ngo', 'organization', 'admin'] })
  @IsEnum(['student', 'ngo', 'organization', 'admin'])
  @IsOptional()
  role?: string;
}
