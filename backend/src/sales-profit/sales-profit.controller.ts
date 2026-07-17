import { Controller, Get } from '@nestjs/common';
import { SalesProfitService } from './sales-profit.service';

@Controller('sales-profit')
export class SalesProfitController {
  constructor(
    private readonly salesProfitService: SalesProfitService,
  ) {}

  @Get()
  getReport() {
    return this.salesProfitService.getReport();
  }
}
