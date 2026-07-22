import { Controller, Get } from '@nestjs/common';
import { DashboardService } from './dashboard.service';

@Controller('dashboard')
export class DashboardController {
  constructor(private dashboardService: DashboardService) {}

  @Get()
  getDashboard() {
    return this.dashboardService.getDashboard();
  }

  @Get('daily')
  getDailyReport() {
    return this.dashboardService.getDashboard();
  }

  @Get('weekly')
  getWeeklyReport() {
    return this.dashboardService.getDashboard();
  }
}
