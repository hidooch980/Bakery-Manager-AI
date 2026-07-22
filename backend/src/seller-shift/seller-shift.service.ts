import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class SellerShiftService {
  constructor(private prisma: PrismaService) {}

  create(data: any) {
    return this.prisma.sellerShift.create({ data });
  }

  findAll() {
    return this.prisma.sellerShift.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  async toggle(id: string) {
    const s = await this.prisma.sellerShift.findUnique({ where: { id } });
    return this.prisma.sellerShift.update({
      where: { id },
      data: { active: !s?.active },
    });
  }
}
