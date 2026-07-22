import { DocumentSequenceService } from '../document-sequence/document-sequence.service';
import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ExpensesService {
  constructor(
    private prisma: PrismaService,
    private documentSequence: DocumentSequenceService,
  ) {}

  findAll() {
    return this.prisma.expense.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  async create(data: any) {
    const expenseNo = await this.documentSequence.next('EXPENSE', 'EXP-');
    return this.prisma.expense.create({
      data: { expenseNo, ...data },
    });
  }
}
