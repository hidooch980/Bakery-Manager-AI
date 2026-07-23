import { Controller, Get, Query } from '@nestjs/common';
import { FinancialReportService } from './financial-report.service';

@Controller('financial-report')
export class FinancialReportController {
  constructor(private readonly service: FinancialReportService) {}

  @Get('monthly')
  monthly(@Query('year') year: string) {
    return this.service.monthly(Number(year));
  }

  @Get('balance-sheet')
  balanceSheet() {
    return this.service.balanceSheet();
  }
}
