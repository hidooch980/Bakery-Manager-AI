import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class AppVersionService {
  constructor(private prisma: PrismaService) {}

  async latest() {
    return this.prisma.appVersion.findFirst({
      where: { active: true },
      orderBy: { buildNumber: 'desc' },
    });
  }

  async history() {
    return this.prisma.appVersion.findMany({
      orderBy: { buildNumber: 'desc' },
    });
  }

  async create(data: any) {
    return this.prisma.appVersion.create({
      data,
    });
  }

  async activate(id: string) {
    await this.prisma.appVersion.updateMany({
      data: { active: false },
    });

    return this.prisma.appVersion.update({
      where: { id },
      data: { active: true },
    });
  }
}
