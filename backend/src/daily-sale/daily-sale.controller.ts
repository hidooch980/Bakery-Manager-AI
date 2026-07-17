import { Controller, Get, Post, Body } from '@nestjs/common';
import { DailySaleService } from './daily-sale.service';

@Controller('daily-sale')
export class DailySaleController {

  constructor(
    private service: DailySaleService
  ) {}


  @Post()
  create(@Body() body:any) {
    return this.service.create(body);
  }


  @Get()
  findAll() {
    return this.service.findAll();
  }


  @Get('today')
  today() {
    return this.service.today();
  }
}
