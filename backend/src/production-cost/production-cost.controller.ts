import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { ProductionCostService } from './production-cost.service';

@Controller('production-cost')
export class ProductionCostController {
  constructor(private readonly productionCostService: ProductionCostService) {}

  @Post()
  create(@Body() data: any) {
    return this.productionCostService.create(data);
  }

  @Get()
  findAll() {
    return this.productionCostService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.productionCostService.findOne(id);
  }
}
