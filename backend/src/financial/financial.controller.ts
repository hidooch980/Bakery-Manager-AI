import { Controller, Get } from '@nestjs/common';
import { FinancialService } from './financial.service';

@Controller('financial')
export class FinancialController {
  constructor(private readonly service: FinancialService) {}

  @Get('daily')
  daily() {
    return this.service.dailyReport();
  }
}
