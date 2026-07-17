import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class NaninoService {
  constructor(private prisma: PrismaService) {}

  async getReport() {
    return {
      status: 'ok',
      module: 'nanino',
      data: await this.prisma.naninoComparison.findMany({
        orderBy: { date: 'desc' },
      }),
    };
  }

  async create(data:any) {
    return this.prisma.naninoComparison.create({
      data:{
        ...data,
        difference: data.sellingDoughCount - data.naninoDoughCount,
        weightDifference: data.sellingWeight - data.naninoWeight,
      }
    });
  }
}
