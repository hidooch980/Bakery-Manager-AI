import { Controller, Get } from '@nestjs/common';

@Controller('production-balance')
export class ProductionBalanceController {
  @Get()
  findAll() {
    return [
      {
        id: 1,
        breadType: { name: 'سنگک' },
        doughCount: 2825,
        saleCount: 2770,
      },
    ];
  }
}
