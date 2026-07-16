import { Module } from '@nestjs/common';
import { CostAnalysisController } from './cost-analysis.controller';
import { CostAnalysisService } from './cost-analysis.service';

@Module({
  controllers: [CostAnalysisController],
  providers: [CostAnalysisService]
})
export class CostAnalysisModule {}
