import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DailyReportService {
  constructor(private prisma: PrismaService) {}

  async report(){

    const sales = await this.prisma.sale.aggregate({
      _sum:{
        total:true,
        cashAmount:true,
        cardAmount:true
      }
    });

    const expenses = await this.prisma.expense.aggregate({
      _sum:{
        amount:true
      }
    });

    const production = await this.prisma.productionBatch.aggregate({
      _sum:{
        breadCount:true,
        doughCount:true,
        flourBags:true
      }
    });

    return {
      production:{
        breadCount:production._sum.breadCount || 0,
        doughCount:production._sum.doughCount || 0,
        flourBags:production._sum.flourBags || 0
      },
      sales:{
        total:sales._sum.total || 0,
        cash:sales._sum.cashAmount || 0,
        card:sales._sum.cardAmount || 0
      },
      expenses:expenses._sum.amount || 0,
      profit:
        (sales._sum.total || 0) -
        (expenses._sum.amount || 0)
    };
  }
}
