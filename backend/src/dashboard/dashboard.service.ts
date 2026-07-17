import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DashboardService {
  constructor(private prisma: PrismaService) {}

  async getDashboard() {
    const sales = await this.prisma.dailySale.aggregate({
      _sum: { totalAmount: true }
    });

    const expenses = await this.prisma.expense.aggregate({
      _sum: { amount: true }
    });

    const nanino = await this.prisma.naninoComparison.findMany({ orderBy: { date: 'desc' }, take: 10 });

    const production = await this.prisma.productionBatch.aggregate({
      _sum: {
        breadCount: true,
        doughCount: true,
        actualDoughCount: true,
        wasteWeight: true,
        totalSale: true
      }
    });

    const totalSales = Number(sales._sum?.totalAmount || 0);
    const totalExpenses = Number(expenses._sum?.amount || 0);

    return {
      status: 'ok',
      module: 'dashboard',
      data: {
        finance: {
          totalSales,
          totalExpenses,
          profit: totalSales - totalExpenses
        },
        production: {
          breadCount: production._sum?.breadCount || 0,
          doughCount: production._sum?.doughCount || 0,
          actualDoughCount: production._sum?.actualDoughCount || 0,
          wasteWeight: production._sum?.wasteWeight || 0,
          productionSale: production._sum?.totalSale || 0
        },
        nanino: {
          records: nanino,
          totalDifference: nanino.reduce((sum, x) => sum + x.difference, 0),
          totalWeightDifference: nanino.reduce((sum, x) => sum + x.weightDifference, 0)
        }
      }
    };
  }
}
