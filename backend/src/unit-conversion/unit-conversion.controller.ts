import { Controller, Get, Post, Body } from '@nestjs/common';
import { UnitConversionService } from './unit-conversion.service';

@Controller('unit-conversion')
export class UnitConversionController {
  constructor(private readonly service: UnitConversionService) {}

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Post()
  create(@Body() data: any) {
    return this.service.create(data);
  }
}
