import { Controller, Get, Post, Body } from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { ExpensesService } from './expenses.service';

@Controller('expenses')
export class ExpensesController {
  constructor(private readonly service: ExpensesService) {}

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
