import { Controller, Get, Post, Body } from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { FlourSaleService } from './flour-sale.service';

@Controller('flour-sale')
export class FlourSaleController {
  constructor(private readonly service: FlourSaleService) {}

  @Get()
  @Roles('MANAGER', 'ACCOUNTANT', 'SELLER')
  findAll() {
    return this.service.findAll();
  }

  @Post()
  @Roles('MANAGER', 'ACCOUNTANT', 'SELLER')
  create(@Body() data: any) {
    return this.service.create(data);
  }
}
