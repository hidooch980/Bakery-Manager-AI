import { Module } from '@nestjs/common';
import { SalesProfitController } from './sales-profit.controller';
import { SalesProfitService } from './sales-profit.service';

@Module({
  controllers: [SalesProfitController],
  providers: [SalesProfitService]
})
export class SalesProfitModule {}
