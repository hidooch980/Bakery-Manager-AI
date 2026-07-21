import { Controller, Get, Post, Body } from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { CashboxService } from './cashbox.service';

@Controller('cashbox')
export class CashboxController {
  constructor(private readonly service: CashboxService) {}

  @Get()
  @Roles('MANAGER','ACCOUNTANT')
  findAll() {
    return this.service.findAll();
  }

  @Post()
  @Roles('MANAGER','ACCOUNTANT')
  create(@Body() data: any) {
    return this.service.create(data);
  }
}
