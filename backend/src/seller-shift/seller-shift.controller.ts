import { Controller, Get, Post, Body, Put, Param } from '@nestjs/common';
import { SellerShiftService } from './seller-shift.service';

@Controller('seller-shift')
export class SellerShiftController {
  constructor(private service: SellerShiftService) {}

  @Post()
  create(@Body() data: any) {
    return this.service.create(data);
  }

  @Get()
  findAll() {
    return this.service.findAll();
  }
  @Put(':id/toggle')
  toggle(@Param('id') id: string) {
    return this.service.toggle(id);
  }
}
