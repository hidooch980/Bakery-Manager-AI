import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { EmployeesService } from './employees.service';

@Controller('employees')
export class EmployeesController {
  constructor(private readonly service: EmployeesService){}

  @Post()
  create(@Body() data:any){
    return this.service.createEmployee(data);
  }

  @Get()
  findAll(){
    return this.service.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id:string){
    return this.service.findOne(id);
  }

  @Get(':id/performance')
  performance(@Param('id') id:string){
    return this.service.performance(id);
  }

  @Post('salary')
  salary(@Body() data:any){
    return this.service.addSalary(data);
  }

  @Post('advance')
  advance(@Body() data:any){
    return this.service.addAdvance(data);
  }

  @Post('debt')
  debt(@Body() data:any){
    return this.service.addDebt(data);
  }
}
