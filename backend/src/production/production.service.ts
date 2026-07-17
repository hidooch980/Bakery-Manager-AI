import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProductionService {
  constructor(private readonly prisma: PrismaService) {}

  async create(data: {
    shift: string;
    flourBags: number;
    flourWeight: number;
    doughCount: number;
    breadCount: number;
    note?: string;
  }) {

    return this.prisma.$transaction(async (tx) => {

      const production = await tx.productionBatch.create({
        data,
      });

      const flour = await tx.ingredient.findFirst({
        where: {
          name: 'آرد',
        },
      });

      if (flour) {
      if (flour.quantity < Number(data.flourWeight)) { throw new Error('موجودی آرد کافی نیست'); }

        await tx.ingredient.update({
          where: {
            id: flour.id,
          },
          data: {
            quantity: {
              decrement: Number(data.flourBags) * 40,
            },
          },
        });

        await tx.inventoryTransaction.create({
          data: {
            ingredientId: flour.id,
            type: 'CONSUME',
            quantity: Number(data.flourBags) * 40,
            description: `مصرف آرد تولید شیفت ${data.shift}`,
          },
        });

      }

      return production;

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
      where: {
        id,
      },
    });
  }
}
