import { IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateGoogleDto {
  @ApiProperty({ example: 'google-id-token' })
  @IsString()
  id_token: string;
}
