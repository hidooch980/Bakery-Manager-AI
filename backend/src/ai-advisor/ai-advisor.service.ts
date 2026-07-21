import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AiAdvisorService {
  constructor(private prisma: PrismaService) {}

  async analyze() {
    const production = await this.prisma.productionBatch.aggregate({
      _sum: {
        breadCount: true,
        flourBags: true,
      },
    });

    const sales = await this.prisma.sale.aggregate({
      _sum: {
        total: true,
      },
    });

    const advice: string[] = [];

    const bread = production._sum.breadCount || 0;
    const sale = sales._sum.total || 0;

    if (bread > 0 && sale === 0) {
      advice.push('تولید ثبت شده ولی فروش ثبت نشده است');
    }

    if ((production._sum.flourBags || 0) > 20) {
      advice.push('مصرف آرد امروز بالا بررسی شود');
    }

    if (advice.length === 0) {
      advice.push('وضعیت نانوایی عادی است');
    }

    return {
      status: 'AI_ANALYSIS',
      production,
      sales,
      advice,
    };
  }
}
