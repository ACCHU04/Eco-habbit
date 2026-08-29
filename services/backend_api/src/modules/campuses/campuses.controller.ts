import {
  Controller, Get, Post, Put, Param, Body,
  UseGuards, Req,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AuthGuard } from '../../common/guards/auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { CampusesService } from './campuses.service';
import { CreateCampusDto, UpdateCampusDto, SetCampusDto } from './dto/campus.dto';

@ApiTags('Campuses')
@Controller('campuses')
export class CampusesController {
  constructor(private readonly campusesService: CampusesService) {}

  @Get()
  @ApiOperation({ summary: 'List all active campuses' })
  async getAllActive() {
    return this.campusesService.getAllActive();
  }

  @Get(':slug')
  @ApiOperation({ summary: 'Get campus by slug' })
  async getBySlug(@Param('slug') slug: string) {
    return this.campusesService.getBySlug(slug);
  }

  @Post()
  @ApiBearerAuth()
  @UseGuards(AuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  @ApiOperation({ summary: 'Create a new campus (admin)' })
  async create(@Body() dto: CreateCampusDto) {
    return this.campusesService.create(dto);
  }

  @Put(':slug')
  @ApiBearerAuth()
  @UseGuards(AuthGuard, RolesGuard)
  @Roles('admin', 'super_admin')
  @ApiOperation({ summary: 'Update campus details (admin)' })
  async updateBySlug(@Param('slug') slug: string, @Body() dto: UpdateCampusDto) {
    return this.campusesService.updateBySlug(slug, dto);
  }

  @Put(':slug/deactivate')
  @ApiBearerAuth()
  @UseGuards(AuthGuard, RolesGuard)
  @Roles('super_admin')
  @ApiOperation({ summary: 'Deactivate a campus (super_admin)' })
  async deactivateBySlug(@Param('slug') slug: string) {
    return this.campusesService.deactivateBySlug(slug);
  }
}

@ApiTags('Users')
@Controller('users')
export class UserCampusController {
  constructor(private readonly campusesService: CampusesService) {}

  @Put('me/campus')
  @ApiBearerAuth()
  @UseGuards(AuthGuard)
  @ApiOperation({ summary: 'Set current user campus' })
  async setMyCampus(@Req() req: any, @Body() dto: SetCampusDto) {
    const userId = req.user.id;
    return this.campusesService.setUserCampus(userId, dto.slug);
  }
}
