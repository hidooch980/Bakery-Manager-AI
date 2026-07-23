import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class FlourSaleService {
  constructor(private readonly prisma: PrismaService) {}

  async create(data: any) {
    const unit = data.unit === 'BAG' ? 'BAG' : 'KILO';
    const quantity = Number(data.quantity);
    const unitPrice = Number(data.unitPrice);

    if (!quantity || !unitPrice) {
      throw new BadRequestException('مقدار و قیمت واحد الزامی است');
    }

    const totalAmount = quantity * unitPrice;

    const flour = await this.prisma.ingredient.findFirst({
      where: { name: 'آرد' },
    });

    const sale = await this.prisma.flourSale.create({
      data: {
        unit,
        quantity,
        unitPrice,
        totalAmount,
        note: data.note,
      },
    });

    if (flour) {
      const kgSold = unit === 'BAG' ? quantity * (flour.bagWeight || 50) : quantity;

      await this.prisma.ingredient.update({
        where: { id: flour.id },
        data: { quantity: { decrement: kgSold } },
      });

      await this.prisma.inventoryTransaction.create({
        data: {
          ingredientId: flour.id,
          type: 'SALE',
          quantity: -kgSold,
          description: `فروش ${quantity} ${unit === 'BAG' ? 'کیسه' : 'کیلوگرم'} آرد`,
        },
      });
    }

    return sale;
  }

  findAll() {
    return this.prisma.flourSale.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  async summary() {
    const agg = await this.prisma.flourSale.aggregate({
      _sum: { totalAmount: true },
    });
    return { total: agg._sum.totalAmount || 0 };
  }
}
