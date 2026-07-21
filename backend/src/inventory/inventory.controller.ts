import { CreateInventoryDto } from './dto/create-inventory.dto';
import { Controller, Get, Post, Patch, Param, Body } from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { InventoryService } from './inventory.service';

@Controller('inventory')
export class InventoryController {
  constructor(private service: InventoryService) {}

  @Get()
  @Roles('MANAGER','ACCOUNTANT')
  findAll() {
    return this.service.findAll();
  }

  @Post()
  @Roles('MANAGER','ACCOUNTANT')
  create(@Body() data: CreateInventoryDto) {
    return this.service.create(data);
  }

  @Patch(':id')
  @Roles('MANAGER','ACCOUNTANT')
  update(@Param('id') id: string, @Body() data: CreateInventoryDto) {
    return this.service.update(id, data);
  }

  @Get('low-stock')
  @Roles('MANAGER','ACCOUNTANT')
  lowStock() {
    return this.service.lowStock();
  }

  @Get('report')
  @Roles('MANAGER','ACCOUNTANT')
  report() {
    return this.service.report();
  }

  @Post('merge-flour')
  @Roles('MANAGER','ACCOUNTANT')
  mergeFlour() {
    return this.service.mergeFlourInventory();
  }
}
