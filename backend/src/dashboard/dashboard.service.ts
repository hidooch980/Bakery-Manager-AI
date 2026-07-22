import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DashboardService {
  constructor(private prisma: PrismaService) {}

  async getDashboard() {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);

    const sales = await this.prisma.sale.aggregate({
      _sum: {
        total: true,
      },
      where: {
        createdAt: {
          gte: today,
          lt: tomorrow,
        },
      },
    });

    const expenses = await this.prisma.expense.aggregate({
      _sum: {
        amount: true,
      },
      where: {
        createdAt: {
          gte: today,
          lt: tomorrow,
        },
      },
    });

    const production = await this.prisma.productionBatch.aggregate({
      _sum: {
        breadCount: true,
      },
      where: {
        createdAt: {
          gte: today,
          lt: tomorrow,
        },
      },
    });

    const flour = await this.prisma.flourInventory.aggregate({
      _sum: {
        closingStockBags: true,
      },
    });

    const lastSales = await this.prisma.sale.findMany({
      take: 7,
      orderBy: {
        createdAt: 'desc',
      },
      select: {
        total: true,
        createdAt: true,
      },
    });

    return {
      today: {
        sales: sales._sum.total ?? 0,
        expenses: expenses._sum.amount ?? 0,
        profit:
          (sales._sum.total ?? 0) -
          (expenses._sum.amount ?? 0),
        production: production._sum?.breadCount ?? 0,
      },

      inventory: {
        flour: flour._sum?.closingStockBags ?? 0,
      },

      charts: {
        sales: lastSales,
      },

      generatedAt: new Date(),
    };
  }
}
