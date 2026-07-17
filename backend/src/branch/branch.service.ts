import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class BranchService {
  constructor(private prisma: PrismaService) {}

  create(data: {
    name: string;
    address?: string;
    phone?: string;
  }) {
    return this.prisma.branch.create({
      data,
    });
  }

  findAll() {
    return this.prisma.branch.findMany({
      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  findOne(id: string) {
    return this.prisma.branch.findUnique({
      where: { id },
    });
  }

  update(id: string, data: any) {
    return this.prisma.branch.update({
      where: { id },
      data,
    });
  }

  remove(id: string) {
    return this.prisma.branch.update({
      where: { id },
      data: {
        active: false,
      },
    });
  }
}
