import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProductionSalesControlService {
  constructor(private prisma: PrismaService) {}

  async report(date: any) {
    const production = await this.prisma.productionBatch.aggregate({
      _sum: { breadCount: true, doughCount: true },
    });

    const shifts = await this.prisma.sellerShift.aggregate({
      _sum: { breadReceived: true },
    });

    return {
      production: {
        breadCount: production._sum.breadCount || 0,
        doughCount: production._sum.doughCount || 0,
      },
      sellerDelivered: shifts._sum.breadReceived || 0,
      remaining:
        (production._sum.breadCount || 0) - (shifts._sum.breadReceived || 0),
    };
  }
}
