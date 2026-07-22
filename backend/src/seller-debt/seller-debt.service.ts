import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SellerDebtService {
  constructor(private prisma: PrismaService) {}

  async create(data: any) {
    return this.prisma.sellerDebt.create({
      data: {
        sellerId: data.sellerId,
        title: data.title,
        amount: data.amount,
        note: data.note,
      },
    });
  }

  async sellerDebts(sellerId: string) {
    return this.prisma.sellerDebt.findMany({
      where: { sellerId },
      orderBy: { createdAt: 'desc' },
    });
  }

  async openDebts() {
    return this.prisma.sellerDebt.findMany({
      where: {
        status: 'OPEN',
      },
      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  async payment(id: string, amount: number) {
    const debt = await this.prisma.sellerDebt.findUnique({ where: { id } });

    if (!debt) {
      throw new Error('Seller debt not found');
    }

    const paid = debt.paidAmount + amount;

    return this.prisma.sellerDebt.update({
      where: { id },
      data: {
        paidAmount: paid,
        status: paid >= debt.amount ? 'PAID' : 'OPEN',
        paidAt: paid >= debt.amount ? new Date() : null,
      },
    });
  }

  async approve(id: string, manager: string) {
    return this.prisma.sellerDebt.update({
      where: { id },
      data: {
        approvedBy: manager,
        approvedAt: new Date(),
      },
    });
  }
}
