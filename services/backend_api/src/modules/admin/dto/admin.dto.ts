import {
  IsString,
  IsEnum,
  IsOptional,
  MaxLength,
  MinLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ChangeRoleDto {
  @ApiProperty({
    enum: ['student', 'ngo', 'organization', 'moderator', 'admin', 'super_admin'],
  })
  @IsEnum(['student', 'ngo', 'organization', 'moderator', 'admin', 'super_admin'])
  role: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  @MaxLength(500)
  reason?: string;
}

export class ChangeStatusDto {
  @ApiProperty({ enum: ['active', 'suspended', 'deactivated'] })
  @IsEnum(['active', 'suspended', 'deactivated'])
  status: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  @MaxLength(500)
  reason?: string;
}

export class ResolveReportDto {
  @ApiProperty({ enum: ['resolved', 'dismissed'] })
  @IsEnum(['resolved', 'dismissed'])
  status: 'resolved' | 'dismissed';

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  @MaxLength(500)
  action_taken?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  @MaxLength(500)
  reason?: string;
}

export class AdminQueryDto {
  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  search?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  role?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  status?: string;

  @ApiPropertyOptional({ default: 1 })
  @IsOptional()
  page?: string;

  @ApiPropertyOptional({ default: 20 })
  @IsOptional()
  limit?: string;
}

export class ReportQueryDto {
  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  status?: string;

  @ApiPropertyOptional({ default: 1 })
  @IsOptional()
  page?: string;

  @ApiPropertyOptional({ default: 20 })
  @IsOptional()
  limit?: string;
}

export class AuditLogQueryDto {
  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  admin_id?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  action?: string;

  @ApiPropertyOptional()
  @IsString()
  @IsOptional()
  resource_type?: string;

  @ApiPropertyOptional({ default: 1 })
  @IsOptional()
  page?: string;

  @ApiPropertyOptional({ default: 50 })
  @IsOptional()
  limit?: string;
}
