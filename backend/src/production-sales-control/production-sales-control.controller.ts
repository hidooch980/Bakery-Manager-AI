import { Controller, Get } from '@nestjs/common';
import { ProductionSalesControlService } from './production-sales-control.service';

@Controller('production-sales-control')
export class ProductionSalesControlController {
  constructor(private service: ProductionSalesControlService) {}

  @Get()
  report() {
    return this.service.report(new Date());
  }
}
