import { Controller, Get, Param, NotFoundException } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { DisposalService } from './disposal.service';

@ApiTags('Disposal')
@Controller('disposal-tips')
export class DisposalController {
  constructor(private readonly disposalService: DisposalService) {}

  @Get()
  @ApiOperation({ summary: 'Get all disposal tips' })
  async getAll() {
    return this.disposalService.getAllTips();
  }

  @Get(':category')
  @ApiOperation({ summary: 'Get disposal tips by category' })
  async getByCategory(@Param('category') category: string) {
    const result = await this.disposalService.getTips(category);
    if (!result) throw new NotFoundException(`No tips for category: ${category}`);
    return result;
  }
}
