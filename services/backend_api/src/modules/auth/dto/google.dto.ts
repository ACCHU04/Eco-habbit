import { IsOptional, IsString } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateGoogleDto {
  @ApiPropertyOptional({ example: 'google-id-token' })
  @IsOptional()
  @IsString()
  id_token?: string;

  @ApiPropertyOptional({ example: 'google-oauth-access-token' })
  @IsOptional()
  @IsString()
  access_token?: string;

  @ApiPropertyOptional({ example: 'user@example.com' })
  @IsOptional()
  @IsString()
  email?: string;

  @ApiPropertyOptional({ example: 'John Doe' })
  @IsOptional()
  @IsString()
  full_name?: string;
}
