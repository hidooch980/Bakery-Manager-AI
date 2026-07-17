import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class FinancialReportService {
  constructor(private prisma: PrismaService) {}

  async monthly(year: number) {

    const months = [
      'فروردین','اردیبهشت','خرداد','تیر',
      'مرداد','شهریور','مهر','آبان',
      'آذر','دی','بهمن','اسفند'
    ];

    const report:any[] = [];

    for (let i = 0; i < 12; i++) {

      const start = new Date(year + '-' + String(i+1).padStart(2,'0') + '-01');
      const end = i === 11 ? new Date((year+1)+'-01-01') : new Date(year + '-' + String(i+2).padStart(2,'0') + '-01');

      const sales = await this.prisma.sale.aggregate({
        _sum:{
          total:true,
          cashAmount:true,
          cardAmount:true
        },
        where:{
          createdAt:{
            gte:start,
            lt:end
          }
        }
      });

      const expenses = await this.prisma.expense.aggregate({
        _sum:{
          amount:true
        },
        where:{
          createdAt:{
            gte:start,
            lt:end
          }
        }
      });

      const production = await this.prisma.productionBatch.aggregate({
        _sum:{
          breadCount:true,
          flourBags:true,
          totalSale:true
        },
        where:{
          createdAt:{
            gte:start,
            lt:end
          }
        }
      });

      const productionCost = await this.prisma.productionCost.aggregate({
        _sum:{
          totalCost:true
        },
        where:{
          createdAt:{
            gte:start,
            lt:end
          }
        }
      });

      const income = sales._sum.total || 0;
      const cost =
        (expenses._sum.amount || 0) +
        (productionCost._sum.totalCost || 0);

      report.push({
        month: months[i],
        income,
        cash: sales._sum.cashAmount || 0,
        card: sales._sum.cardAmount || 0,
        expenses: expenses._sum.amount || 0,
        productionCost: productionCost._sum.totalCost || 0,
        profit: income - cost,
        production:{
          breads: production._sum.breadCount || 0,
          flourBags: production._sum.flourBags || 0,
          productionSale: production._sum.totalSale || 0
        }
      });
    }

    return {
      year,
      fiscalYear:'فروردین تا اسفند',
      months:report
    };
  }
}
