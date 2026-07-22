import { Controller, Get } from '@nestjs/common';
import { ProductionControlService } from './production-control.service';

@Controller('production-control')
export class ProductionControlController {
  constructor(private service: ProductionControlService) {}

  @Get('report')
  report() {
    return this.service.report();
  }
}
