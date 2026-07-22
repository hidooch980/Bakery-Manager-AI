import { Controller, Get } from '@nestjs/common';
import { DailyReportService } from './daily-report.service';

@Controller('daily-report')
export class DailyReportController {
  constructor(private service: DailyReportService) {}

  @Get()
  report() {
    return this.service.report();
  }
}
