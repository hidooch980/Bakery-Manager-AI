import { Module } from '@nestjs/common';
import { ProfitDashboardController } from './profit-dashboard.controller';
import { ProfitDashboardService } from './profit-dashboard.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports:[PrismaModule],
  controllers:[ProfitDashboardController],
  providers:[ProfitDashboardService]
})
export class ProfitDashboardModule {}
