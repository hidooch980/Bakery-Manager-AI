import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SalesProfitService {
  constructor(private prisma: PrismaService) {}

  async getReport() {
    const sales = await this.prisma.dailySale.aggregate({
      _sum: { totalAmount: true },
    });

    const expenses = await this.prisma.expense.aggregate({
      _sum: { amount: true },
    });

    const production = await this.prisma.productionBatch.count();

    const totalSales = Number(sales._sum?.totalAmount || 0);
    const totalExpenses = Number(expenses._sum?.amount || 0);

    return {
      status: 'ok',
      module: 'sales-profit',
      data: {
        totalSales,
        totalExpenses,
        netProfit: totalSales - totalExpenses,
        productionCount: production,
        reportDate: new Date(),
      },
    };
  }
}
