import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { EmployeesService } from './employees.service';

@Controller('employees')
export class EmployeesController {
  constructor(private readonly service: EmployeesService) {}

  @Post()
  @Roles('MANAGER')
  create(@Body() data: any) {
    return this.service.createEmployee(data);
  }

  @Get()
  @Roles('MANAGER')
  findAll() {
    return this.service.findAll();
  }

  @Get(':id')
  @Roles('MANAGER')
  findOne(@Param('id') id: string) {
    return this.service.findOne(id);
  }

  @Get(':id/performance')
  @Roles('MANAGER')
  performance(@Param('id') id: string) {
    return this.service.performance(id);
  }

  @Post('salary')
  @Roles('MANAGER')
  salary(@Body() data: any) {
    return this.service.addSalary(data);
  }

  @Post('advance')
  @Roles('MANAGER')
  advance(@Body() data: any) {
    return this.service.addAdvance(data);
  }

  @Post('debt')
  @Roles('MANAGER')
  debt(@Body() data: any) {
    return this.service.addDebt(data);
  }
}
