import { Controller, Get, Post, Body } from '@nestjs/common';
import { NaninoService } from './nanino.service';

@Controller('nanino')
export class NaninoController {
  constructor(private readonly naninoService: NaninoService) {}

  @Get()
  getReport() {
    return this.naninoService.getReport();
  }

  @Post()
  create(@Body() body: any) {
    return this.naninoService.create(body);
  }
}
