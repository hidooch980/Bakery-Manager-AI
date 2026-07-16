import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class CashboxService {
  constructor(private prisma: PrismaService) {}

  findAll() {
    return this.prisma.cashBox.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  create(data: any) {
    return this.prisma.cashBox.create({
      data,
    });
  }
}
