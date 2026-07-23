import { IsString, IsEnum, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export enum NotificationType {
  like_comment = 'like_comment',
  marketplace_inquiry = 'marketplace_inquiry',
  reward_achievement = 'reward_achievement',
  community_update = 'community_update',
}

export class CreateNotificationDto {
  @ApiProperty({
    enum: NotificationType,
    example: NotificationType.like_comment,
  })
  @IsEnum(NotificationType)
  type: NotificationType;

  @ApiProperty({ example: 'New like on your post' })
  @IsString()
  title: string;

  @ApiProperty({ example: 'Someone liked your DIY project post' })
  @IsString()
  body: string;

  @ApiPropertyOptional({ example: { post_id: 'abc-123' } })
  @IsOptional()
  data?: Record<string, unknown>;
}
