import { Controller, Get } from '@nestjs/common';
import { ProfitDashboardService } from './profit-dashboard.service';

@Controller('profit-dashboard')
export class ProfitDashboardController {
 constructor(private service: ProfitDashboardService){}

 @Get()
 get(){
  return this.service.get();
 }
}
