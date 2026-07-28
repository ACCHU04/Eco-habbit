import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  UseGuards,
  Req,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
} from '@nestjs/swagger';
import { AuthGuard } from '../../common/guards/auth.guard';
import { HostelsService } from './hostels.service';

@ApiTags('Hostels')
@Controller('hostels')
export class HostelsController {
  constructor(private readonly hostelsService: HostelsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all hostels' })
  @ApiQuery({ name: 'college', required: false })
  async getAllHostels(@Query('college') college?: string) {
    return this.hostelsService.getAllHostels(college);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get hostel by ID' })
  async getHostel(@Param('id') id: string) {
    return this.hostelsService.getHostelById(id);
  }

  @Get(':name/members')
  @ApiOperation({ summary: 'Get hostel members' })
  @ApiQuery({ name: 'limit', required: false })
  async getHostelMembers(
    @Param('name') name: string,
    @Query('limit') limit?: string,
  ) {
    return this.hostelsService.getHostelMembers(
      name,
      limit ? parseInt(limit, 10) : undefined,
    );
  }

  @Post('join')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Join a hostel' })
  async joinHostel(@Req() req: any, @Body() body: { hostel_name: string }) {
    return this.hostelsService.joinHostel(req.user.id, body.hostel_name);
  }

  @Get('battles/all')
  @ApiOperation({ summary: 'Get all active/completed battles' })
  @ApiQuery({ name: 'hostel_id', required: false })
  async getBattles(@Query('hostel_id') hostelId?: string) {
    return this.hostelsService.getActiveBattles(hostelId);
  }

  @Post('battles/create')
  @UseGuards(AuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Create a hostel battle' })
  async createBattle(
    @Body()
    body: {
      title: string;
      description: string;
      hosteler_id: string;
      hosteler_challenger: string;
      metric?: string;
      duration_days?: number;
    },
  ) {
    return this.hostelsService.createBattle(
      body.title,
      body.description,
      body.hosteler_id,
      body.hosteler_challenger,
      body.metric || 'total_score',
      body.duration_days || 7,
    );
  }

  @Get('battles/:id')
  @ApiOperation({ summary: 'Get battle details' })
  async getBattle(@Param('id') id: string) {
    return this.hostelsService.getBattleById(id);
  }
}
