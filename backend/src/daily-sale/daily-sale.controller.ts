import { Controller, Get, Post, Body } from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { DailySaleService } from './daily-sale.service';

@Controller('daily-sale')
export class DailySaleController {
  constructor(private service: DailySaleService) {}

  @Post()
  @Roles('MANAGER', 'SELLER')
  create(@Body() body: any) {
    return this.service.create(body);
  }

  @Get()
  @Roles('MANAGER', 'SELLER')
  findAll() {
    return this.service.findAll();
  }

  @Get('today')
  @Roles('MANAGER', 'SELLER')
  today() {
    return this.service.today();
  }
}
