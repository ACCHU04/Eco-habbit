import { IsEmail, IsString, MinLength, IsEnum } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateRegisterDto {
  @ApiProperty({ example: 'user@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'password123' })
  @IsString()
  @MinLength(8)
  password: string;

  @ApiProperty({ example: 'John Doe' })
  @IsString()
  full_name: string;

  @ApiProperty({ example: 'IIT Delhi' })
  @IsString()
  college: string;

  @ApiProperty({ enum: ['student', 'ngo', 'organization'] })
  @IsEnum(['student', 'ngo', 'organization'])
  role: string;
}
