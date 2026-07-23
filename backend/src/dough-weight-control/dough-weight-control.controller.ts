import { Controller, Get, Post, Body } from '@nestjs/common';
import { Roles } from '../auth/roles/roles.decorator';
import { DoughWeightControlService } from './dough-weight-control.service';

@Controller('dough-weight-control')
export class DoughWeightControlController {
  constructor(private readonly service: DoughWeightControlService) {}

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
