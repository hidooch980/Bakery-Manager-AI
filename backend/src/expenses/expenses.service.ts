import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ExpensesService {
  constructor(private prisma: PrismaService) {}

  findAll() {
    return this.prisma.expense.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  create(data: any) {
    return this.prisma.expense.create({
      data,
    });
  }
}
