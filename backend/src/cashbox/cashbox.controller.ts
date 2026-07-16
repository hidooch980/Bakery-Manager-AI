import { Controller, Get, Post, Body } from '@nestjs/common';
import { CashboxService } from './cashbox.service';

@Controller('cashbox')
export class CashboxController {

  constructor(
    private readonly service: CashboxService,
  ) {}

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Post()
  create(@Body() data:any) {
    return this.service.create(data);
  }
}
