import { Body, Controller, Get, Post } from '@nestjs/common';
import { FlourControlService } from './flour-control.service';

@Controller('flour-control')
export class FlourControlController {
  constructor(private service: FlourControlService) {}

  @Post()
  create(@Body() data: any) {
    return this.service.create(data);
  }

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Get('report')
  report() {
    return this.service.report();
  }
}
