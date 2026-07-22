import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProductionCostService {
  constructor(private readonly prisma: PrismaService) {}

  create(data: any) {
    return this.prisma.productionCost.create({
      data: {
        productionId: data.productionId,
        flourKg: data.flourKg,
        waterLiter: data.waterLiter,
        doughCount: data.doughCount,
        breadCount: data.breadCount,
        breadWeight: data.breadWeight,
        flourCost: data.flourCost || 0,
        waterCost: data.waterCost || 0,
        energyCost: data.energyCost || 0,
        laborCost: data.laborCost || 0,
        totalCost: data.totalCost || 0,
      },
    });
  }

  findAll() {
    return this.prisma.productionCost.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  findOne(id: string) {
    return this.prisma.productionCost.findUnique({
      where: { id },
    });
  }
}
