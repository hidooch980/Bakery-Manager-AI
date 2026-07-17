import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class BakerySettingsService {
  constructor(private prisma: PrismaService) {}

  create(data: any) {
    return this.prisma.bakerySettings.create({ data: { saleWeights: data.saleWeights, naninoWeights: data.naninoWeights } });
  }

  findAll() {
    return this.prisma.bakerySettings.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  update(id: string, data: any) {
    return this.prisma.bakerySettings.update({
      where: { id },
      data,
    });
  }
}
