import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { ProductionService } from './production.service';

@Controller('production')
export class ProductionController {
  constructor(private readonly productionService: ProductionService) {}

  @Post()
  @Roles('MANAGER','DOUGH_MAKER')
  create(@Body() data: any) {
    return this.productionService.create(data);
  }

  @Get()
  @Roles('MANAGER','ACCOUNTANT')
  findAll() {
    return this.productionService.findAll();
  }

  @Get(':id')
  @Roles('MANAGER','DOUGH_MAKER')
  findOne(@Param('id') id: string) {
    return this.productionService.findOne(id);
  }
}
