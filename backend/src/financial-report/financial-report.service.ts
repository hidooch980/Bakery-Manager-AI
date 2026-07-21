import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import moment from 'jalali-moment';

@Injectable()
export class FinancialReportService {
  constructor(private prisma: PrismaService) {}

  async monthly(year: number) {
    const months = [
      'فروردین',
      'اردیبهشت',
      'خرداد',
      'تیر',
      'مرداد',
      'شهریور',
      'مهر',
      'آبان',
      'آذر',
      'دی',
      'بهمن',
      'اسفند',
    ];

    const report: any[] = [];

    for (let i = 1; i <= 12; i++) {
      const start = moment(`${year}/${i}/1`, 'jYYYY/jM/jD')
        .startOf('day')
        .toDate();

      const end =
        i === 12
          ? moment(`${year + 1}/1/1`, 'jYYYY/jM/jD').toDate()
          : moment(`${year}/${i + 1}/1`, 'jYYYY/jM/jD').toDate();

      const sales = await this.prisma.sale.aggregate({
        _sum: {
          total: true,
          cashAmount: true,
          cardAmount: true,
        },
        where: {
          createdAt: {
            gte: start,
            lt: end,
          },
        },
      });

      const expenses = await this.prisma.expense.aggregate({
        _sum: {
          amount: true,
        },
        where: {
          createdAt: {
            gte: start,
            lt: end,
          },
        },
      });

      const productionCost = await this.prisma.productionCost.aggregate({
        _sum: {
          totalCost: true,
        },
        where: {
          createdAt: {
            gte: start,
            lt: end,
          },
        },
      });

      const income = sales._sum.total || 0;

      const expense =
        (expenses._sum.amount || 0) + (productionCost._sum.totalCost || 0);

      report.push({
        month: months[i - 1],
        income,
        cash: sales._sum.cashAmount || 0,
        card: sales._sum.cardAmount || 0,
        expenses: expenses._sum.amount || 0,
        productionCost: productionCost._sum.totalCost || 0,
        profit: income - expense,
      });
    }

    return {
      year,
      fiscalYear: 'فروردین تا اسفند',
      months: report,
    };
  }
}
