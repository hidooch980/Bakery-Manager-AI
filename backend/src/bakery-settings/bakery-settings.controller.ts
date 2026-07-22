import { Body, Controller, Get, Param, Patch, Post } from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { BakerySettingsService } from './bakery-settings.service';

@Controller('bakery-settings')
export class BakerySettingsController {
  constructor(private service: BakerySettingsService) {}

  @Post()
  @Roles('MANAGER')
  create(@Body() data: any) {
    return this.service.create(data);
  }

  @Get()
  @Roles('MANAGER')
  findAll() {
    return this.service.findAll();
  }

  @Patch(':id')
  @Roles('MANAGER')
  update(@Param('id') id: string, @Body() data: any) {
    return this.service.update(id, data);
  }
}
