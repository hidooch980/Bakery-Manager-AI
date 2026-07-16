import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ReportsService {
  constructor(private prisma: PrismaService) {}

  async daily() {
    const sales = await this.prisma.sale.aggregate({
      _sum: { total: true },
    });

    const expenses = await this.prisma.expense.aggregate({
      _sum: { amount: true },
    });

    const cash = await this.prisma.cashBox.aggregate({
      _sum: { balance: true },
    });

    const salesCount = await this.prisma.sale.count();

    const totalSales = sales._sum.total || 0;
    const totalExpenses = expenses._sum.amount || 0;

    return {
      sales: totalSales,
      expenses: totalExpenses,
      profit: totalSales - totalExpenses,
      cashBalance: cash._sum.balance || 0,
      salesCount,
    };
  }
}


