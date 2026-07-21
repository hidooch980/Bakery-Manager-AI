import { Injectable } from '@nestjs/common';

@Injectable()
export class ProductionBalanceService {
  getBalance() {
    return [
      {
        id: 1,
        breadType: { name: 'نان تافتون' },
        doughCount: 2825,
        saleCount: 2770,
        difference: 55,
      },
    ];
  }
}
