import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProfitDashboardService {
  constructor(private prisma: PrismaService) {}

  async get() {
    // قبلاً این سرویس stub بود و همیشه صفر برمی‌گرداند؛
    // حالا مقادیر واقعی از دیتابیس محاسبه می‌شود.
    const [sales, expenses, production] = await Promise.all([
      this.prisma.sale.aggregate({
        _sum: { total: true, cashAmount: true, cardAmount: true },
      }),
      this.prisma.expense.aggregate({
        _sum: { amount: true },
      }),
      this.prisma.productionBatch.aggregate({
        _sum: { totalSale: true, breadCount: true, flourBags: true },
      }),
    ]);

    const totalSales =
      (sales._sum.total || 0) + (production._sum.totalSale || 0);
    const totalCost = expenses._sum.amount || 0;

    return {
      totalSales,
      totalCost,
      profit: totalSales - totalCost,
      breakdown: {
        salesTotal: sales._sum.total || 0,
        salesCash: sales._sum.cashAmount || 0,
        salesCard: sales._sum.cardAmount || 0,
        productionSales: production._sum.totalSale || 0,
        expenses: expenses._sum.amount || 0,
        breadCount: production._sum.breadCount || 0,
        flourBags: production._sum.flourBags || 0,
      },
    };
  }
}
