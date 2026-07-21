import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class UnitConversionService {
  constructor(private prisma: PrismaService) {}

  findAll() {
    return this.prisma.unitConversion.findMany({
      include: {
        ingredient: true,
      },
      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  create(data: any) {
    return this.prisma.unitConversion.create({
      data,
    });
  }
}
