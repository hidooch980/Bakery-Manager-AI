import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class FlourControlService {
  constructor(private prisma: PrismaService) {}

  create(data: any) {
    return this.prisma.flourInventory.create({ data });
  }

  findAll() {
    return this.prisma.flourInventory.findMany({
      orderBy: { date: 'desc' },
    });
  }

  report() {
    return this.prisma.flourInventory.aggregate({
      _sum: {
        openingStockBags: true,
        factoryReceivedBags: true,
        purchasedBags: true,
        consumedBags: true,
        closingStockBags: true,
      },
    });
  }
}
