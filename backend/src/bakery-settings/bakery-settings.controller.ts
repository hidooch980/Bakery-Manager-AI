import { Body, Controller, Get, Param, Patch, Post } from '@nestjs/common';
import { BakerySettingsService } from './bakery-settings.service';

@Controller('bakery-settings')
export class BakerySettingsController {
  constructor(private service: BakerySettingsService) {}

  @Post()
  create(@Body() data: any) {
    return this.service.create(data);
  }

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() data: any) {
    return this.service.update(id, data);
  }
}
