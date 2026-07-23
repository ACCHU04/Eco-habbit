import { IsString, IsEnum, IsArray, IsOptional, IsUUID, MaxLength } from 'class-validator';

export class CreatePostDto {
  @IsEnum(['diy', 'tip', 'marketplace'] as const)
  post_type: 'diy' | 'tip' | 'marketplace';

  @IsString()
  @MaxLength(5000)
  content: string;

  @IsArray()
  @IsOptional()
  image_urls?: string[];

  @IsUUID()
  @IsOptional()
  diy_project_id?: string;

  @IsUUID()
  @IsOptional()
  marketplace_listing_id?: string;
}

export class CreateCommentDto {
  @IsString()
  @MaxLength(2000)
  content: string;
}

export class CreateReportDto {
  @IsEnum(['marketplace_listing', 'post', 'comment'] as const)
  content_type: 'marketplace_listing' | 'post' | 'comment';

  @IsUUID()
  content_id: string;

  @IsEnum(['spam', 'inappropriate', 'scam', 'other'] as const)
  reason: 'spam' | 'inappropriate' | 'scam' | 'other';

  @IsString()
  @IsOptional()
  @MaxLength(1000)
  description?: string;
}

export class ResolveReportDto {
  @IsEnum(['resolved', 'dismissed'] as const)
  status: 'resolved' | 'dismissed';

  @IsString()
  @IsOptional()
  @MaxLength(500)
  action_taken?: string;
}
