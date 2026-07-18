import { Controller, Get, Post, Body, Param, Patch } from '@nestjs/common';
import { AppVersionService } from './app-version.service';

@Controller('app-version')
export class AppVersionController {
  constructor(private readonly service: AppVersionService) {}

  @Get('latest')
  latest() {
    return this.service.latest();
  }

  @Get('history')
  history() {
    return this.service.history();
  }

  @Post()
  create(@Body() body: any) {
    return this.service.create(body);
  }

  @Patch(':id/activate')
  activate(@Param('id') id: string) {
    return this.service.activate(id);
  }
}
