import { CreateSaleDto } from './dto/create-sale.dto';
import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { SalesService } from './sales.service';

@Controller('sales')
export class SalesController {
  constructor(private service: SalesService) {}

  @Get()
  @Roles('MANAGER','SELLER')
  findAll() {
    return this.service.findAll();
  }

  @Get('seller-report/:employeeId')
  @Roles('MANAGER','SELLER')
  sellerReport(@Param('employeeId') employeeId: string) {
    return this.service.sellerReport(employeeId);
  }

  @Post()
  @Roles('MANAGER','SELLER')
  create(@Body() data: CreateSaleDto) {
    return this.service.create(data);
  }
}
