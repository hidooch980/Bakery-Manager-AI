import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class FinancialService {
  constructor(private readonly prisma: PrismaService) {}

  async summary() {
    const sales = await this.prisma.sale.aggregate({
      _sum: {
        total: true,
      },
    });

    const expenses = await this.prisma.expense.aggregate({
      _sum: {
        amount: true,
      },
    });

    const salaries = await this.prisma.salary.aggregate({
      _sum: {
        amount: true,
      },
    });

    const income = sales._sum?.total || 0;
    const cost = (expenses._sum?.amount || 0) + (salaries._sum?.amount || 0);

    return {
      income,
      expenses: expenses._sum?.amount || 0,
      salaries: salaries._sum?.amount || 0,
      profit: income - cost,
    };
  }

  async dailyReport() {
    return this.summary();
  }
}
