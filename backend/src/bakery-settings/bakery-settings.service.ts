import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class BakerySettingsService {
  constructor(private prisma: PrismaService) {}

  create(data: any) {
    return this.prisma.bakerySetting.create({ data });
  }

  findAll() {
    return this.prisma.bakerySetting.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  update(id: string, data: any) {
    return this.prisma.bakerySetting.update({
      where: { id },
      data,
    });
  }
}
