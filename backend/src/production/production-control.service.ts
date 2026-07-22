import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProductionControlService {
  constructor(private prisma: PrismaService) {}

  async report() {
    const data = await this.prisma.productionBatch.findMany({
      orderBy: { createdAt: 'desc' },
    });

    return data.map((p) => ({
      date: p.createdAt,
      shift: p.shift,
      produced: p.breadCount,
      sold: p.soldBreadCount,
      shortage: p.breadCount - p.soldBreadCount,
      doughWeight: p.doughWeight,
    }));
  }
}
