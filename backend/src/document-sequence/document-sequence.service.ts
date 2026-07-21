import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DocumentSequenceService {
  constructor(private prisma: PrismaService) {}

  async next(document: string, prefix: string) {
    const seq = await this.prisma.documentSequence.upsert({
      where: { document },
      update: { currentNo: { increment: 1 } },
      create: { document, prefix, currentNo: 1 },
    });
    return `${prefix}${String(seq.currentNo).padStart(seq.digits, '0')}`;
  }
}
