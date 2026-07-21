import { DocumentSequenceService } from '../document-sequence/document-sequence.service';
import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SalesService {
  constructor(
    private prisma: PrismaService,
    private documentSequence: DocumentSequenceService,
  ) {}

  async create(data: any) {
    return this.prisma.$transaction(async (tx) => {
      const itemsWithPrice = await Promise.all(
        data.items.map(async (item: any) => {
          const product = await tx.product.findUnique({
            where: { id: item.productId },
          });

          if (!product) {
            throw new NotFoundException(`Product not found`);
          }

          if (product.stock < item.quantity) {
            throw new BadRequestException(`Insufficient stock`);
          }

          return {
            productId: item.productId,
            quantity: item.quantity,
            price: product.price,
          };
        }),
      );

      const total = itemsWithPrice.reduce(
        (sum: any, item: any) => sum + item.price * item.quantity,
        0,
      );

      const sale = await tx.sale.create({
        data: {
          total,
          items: {
            create: itemsWithPrice,
          },
        },
        include: {
          items: true,
        },
      });

      await tx.cashBox.create({
        data: {
          balance: total,
        },
      });

      for (const item of itemsWithPrice) {
        await tx.product.update({
          where: {
            id: item.productId,
          },
          data: {
            stock: {
              decrement: item.quantity,
            },
          },
        });
      }

      return sale;
    });
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
