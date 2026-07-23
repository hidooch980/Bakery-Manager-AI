import { Controller, Get, Post, Body } from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { FlourPurchaseService } from './flour-purchase.service';

@Controller('flour-purchase')
export class FlourPurchaseController {
  constructor(private readonly service: FlourPurchaseService) {}

  @Get()
  @Roles('MANAGER', 'ACCOUNTANT')
  findAll() {
    return this.service.findAll();
  }

  @Post()
  @Roles('MANAGER', 'ACCOUNTANT')
  create(@Body() data: any) {
    return this.service.create(data);
  }
}
