import {
  Controller,
  Get,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiQuery,
} from '@nestjs/swagger';
import { AuthGuard } from '../../common/guards/auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { AdminService } from './admin.service';
import { AdminOnlyGuard } from './guards/admin-only.guard';
import {
  ChangeRoleDto,
  ChangeStatusDto,
  ResolveReportDto,
  AdminQueryDto,
  ReportQueryDto,
  AuditLogQueryDto,
} from './dto/admin.dto';

@ApiTags('Admin')
@ApiBearerAuth()
@Controller('admin')
@UseGuards(AuthGuard, RolesGuard, AdminOnlyGuard)
@Roles('admin', 'super_admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('dashboard')
  @ApiOperation({ summary: 'Admin dashboard overview stats' })
  async getDashboard() {
    return this.adminService.getDashboard();
  }

  @Get('users')
  @ApiOperation({ summary: 'List users with search, role, and status filters' })
  @ApiQuery({ name: 'search', required: false })
  @ApiQuery({ name: 'role', required: false })
  @ApiQuery({ name: 'status', required: false })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getUsers(@Query() query: AdminQueryDto) {
    return this.adminService.getUsers({
      search: query.search,
      role: query.role,
      status: query.status,
      page: query.page ? parseInt(query.page, 10) : undefined,
      limit: query.limit ? parseInt(query.limit, 10) : undefined,
    });
  }

  @Get('users/:id')
  @ApiOperation({ summary: 'Get user detail with stats' })
  async getUserDetail(@Param('id') id: string) {
    return this.adminService.getUserDetail(id);
  }

  @Put('users/:id/role')
  @Roles('super_admin')
  @ApiOperation({ summary: 'Change user role (super_admin only for admin+ roles)' })
  async changeRole(
    @CurrentUser('id') adminId: string,
    @Param('id') targetUserId: string,
    @Body() dto: ChangeRoleDto,
  ) {
    return this.adminService.changeUserRole(
      adminId,
      targetUserId,
      dto.role,
      dto.reason,
    );
  }

  @Put('users/:id/status')
  @ApiOperation({ summary: 'Suspend or reactivate a user' })
  async changeStatus(
    @CurrentUser('id') adminId: string,
    @Param('id') targetUserId: string,
    @Body() dto: ChangeStatusDto,
  ) {
    return this.adminService.changeUserStatus(
      adminId,
      targetUserId,
      dto.status,
      dto.reason,
    );
  }

  @Get('reports')
  @ApiOperation({ summary: 'List reports with status filter' })
  @ApiQuery({ name: 'status', required: false })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getReports(@Query() query: ReportQueryDto) {
    return this.adminService.getReports({
      status: query.status,
      page: query.page ? parseInt(query.page, 10) : undefined,
      limit: query.limit ? parseInt(query.limit, 10) : undefined,
    });
  }

  @Put('reports/:id')
  @ApiOperation({ summary: 'Resolve or dismiss a report' })
  async resolveReport(
    @CurrentUser('id') adminId: string,
    @Param('id') reportId: string,
    @Body() dto: ResolveReportDto,
  ) {
    return this.adminService.resolveReport(adminId, reportId, dto);
  }

  @Delete('posts/:id')
  @ApiOperation({ summary: 'Remove a post (admin moderation)' })
  async deletePost(
    @CurrentUser('id') adminId: string,
    @Param('id') postId: string,
    @Query('reason') reason?: string,
  ) {
    return this.adminService.deletePost(adminId, postId, reason);
  }

  @Delete('listings/:id')
  @ApiOperation({ summary: 'Remove a marketplace listing (admin moderation)' })
  async deleteListing(
    @CurrentUser('id') adminId: string,
    @Param('id') listingId: string,
    @Query('reason') reason?: string,
  ) {
    return this.adminService.deleteListing(adminId, listingId, reason);
  }

  @Get('audit-log')
  @ApiOperation({ summary: 'View admin audit log' })
  @ApiQuery({ name: 'admin_id', required: false })
  @ApiQuery({ name: 'action', required: false })
  @ApiQuery({ name: 'resource_type', required: false })
  @ApiQuery({ name: 'page', required: false })
  @ApiQuery({ name: 'limit', required: false })
  async getAuditLog(@Query() query: AuditLogQueryDto) {
    return this.adminService.getAuditLog({
      admin_id: query.admin_id,
      action: query.action,
      resource_type: query.resource_type,
      page: query.page ? parseInt(query.page, 10) : undefined,
      limit: query.limit ? parseInt(query.limit, 10) : undefined,
    });
  }
}
