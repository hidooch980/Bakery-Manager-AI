import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { DailyReportController } from './daily-report.controller';
import { DailyReportService } from './daily-report.service';

@Module({
 imports:[PrismaModule],
 controllers:[DailyReportController],
 providers:[DailyReportService]
})
export class DailyReportModule {}
