import { Controller, Get, Post, Body } from '@nestjs/common';
import { ExpensesService } from './expenses.service';

@Controller('expenses')
export class ExpensesController {

  constructor(
    private readonly service: ExpensesService,
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
