import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AiForecastService {
  constructor(private prisma: PrismaService) {}

  async forecast() {
    const sales = await this.prisma.sale.aggregate({
      _sum: { total: true },
    });

    const production = await this.prisma.productionBatch.aggregate({
      _sum: {
        breadCount: true,
        doughCount: true,
        flourBags: true,
      },
    });

    const avgBread = production._sum.breadCount || 0;
    const avgDough = production._sum.doughCount || 0;
    const avgFlour = production._sum.flourBags || 0;

    return {
      status: 'AI_FORECAST',
      prediction: {
        recommendedBread: Math.round(avgBread),
        recommendedDough: Math.round(avgDough),
        recommendedFlourBags: avgFlour,
      },
      basedOn: {
        sales: sales._sum.total || 0,
      },
    };
  }
}
