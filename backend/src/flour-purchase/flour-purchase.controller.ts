import { Controller, Get, Post, Body } from '@nestjs/common';
import { FlourPurchaseService } from './flour-purchase.service';

@Controller('flour-purchase')
export class FlourPurchaseController {
  constructor(private readonly service: FlourPurchaseService) {}

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Post()
  create(@Body() data: any) {
    return this.service.create(data);
  }
}
