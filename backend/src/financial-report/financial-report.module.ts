import { PrismaModule } from '../prisma/prisma.module';
import { Module } from '@nestjs/common';
import { FinancialReportController } from './financial-report.controller';
import { FinancialReportService } from './financial-report.service';

@Module({
  imports: [PrismaModule],
  controllers: [FinancialReportController],
  providers: [FinancialReportService],
})
export class FinancialReportModule {}
