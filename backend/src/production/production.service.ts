import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProductionService {
  constructor(private readonly prisma: PrismaService) {}

  create(data: {
    shift: string;
    flourBags: number;
    flourWeight: number;
    doughCount: number;
    breadCount: number;
    note?: string;
  }) {
    return this.prisma.productionBatch.create({
      data,
    });
  }

  findAll() {
    return this.prisma.productionBatch.findMany({
      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  findOne(id: string) {
    return this.prisma.productionBatch.findUnique({
      where: { id },
    });
  }
}
