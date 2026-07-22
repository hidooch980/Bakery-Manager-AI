import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SalesService {
  constructor(private prisma: PrismaService) {}

  async create(data: any) {
    const sale = await this.prisma.sale.create({
      data: {
        total: data.total,
        items: {
          create: data.items,
        },
      },
      include: {
        items: true,
      },
    });

    await this.prisma.cashBox.create({
      data: {
        balance: data.total,
      },
    });

    for (const item of data.items) {
      await this.prisma.product.update({
        where: { id: item.productId },
        data: {
          stock: {
            decrement: item.quantity,
          },
        },
      });
    }

    return sale;
  }

  sellerReport(employeeId: string) {
    return this.prisma.sale.findMany({
      where: { employeeId },
      include: { items: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  findAll() {
    return this.prisma.sale.findMany({
      include: { items: true },
      orderBy: { createdAt: 'desc' },
    });
  }
}
