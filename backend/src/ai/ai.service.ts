import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AiService {
  constructor(private prisma: PrismaService) {}

  async forecast() {
    const sales = await this.prisma.sale.findMany({
      orderBy: { createdAt: 'desc' },
      take: 30,
    });

    const total = sales.reduce((sum, s) => sum + s.total, 0);
    const average = sales.length ? total / sales.length : 0;

    return {
      samples: sales.length,
      totalSales: total,
      averageSale: average,
      forecastNextDay: Math.round(average * 1.1),
      message: 'AI forecast generated',
    };
  }
}
