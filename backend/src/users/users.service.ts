import {
  Injectable,
  ConflictException,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findAll() {
    const users = await this.prisma.user.findMany({
      orderBy: { createdAt: 'desc' },
    });
    return users.map((u) => this.sanitize(u));
  }

  async findOne(id: string) {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) {
      throw new NotFoundException('کاربر یافت نشد');
    }
    return this.sanitize(user);
  }

  async create(data: {
    name: string;
    phone: string;
    password: string;
    role?: string;
  }) {
    const existing = await this.prisma.user.findUnique({
      where: { phone: data.phone },
    });
    if (existing) {
      throw new ConflictException('این شماره موبایل قبلاً ثبت شده است');
    }

    const hashedPassword = await bcrypt.hash(data.password, 10);

    const user = await this.prisma.user.create({
      data: {
        name: data.name,
        phone: data.phone,
        password: hashedPassword,
        role: data.role || 'EMPLOYEE',
      },
    });

    return this.sanitize(user);
  }

  async update(
    id: string,
    data: { name?: string; role?: string; password?: string },
  ) {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) {
      throw new NotFoundException('کاربر یافت نشد');
    }

    const updateData: Record<string, unknown> = {};
    if (data.name !== undefined) updateData.name = data.name;
    if (data.role !== undefined) updateData.role = data.role;
    if (data.password) {
      updateData.password = await bcrypt.hash(data.password, 10);
    }

    const updated = await this.prisma.user.update({
      where: { id },
      data: updateData,
    });

    return this.sanitize(updated);
  }

  async remove(id: string) {
    const user = await this.prisma.user.findUnique({ where: { id } });
    if (!user) {
      throw new NotFoundException('کاربر یافت نشد');
    }
    await this.prisma.user.delete({ where: { id } });
    return { success: true };
  }

  private sanitize(user: {
    id: string;
    name: string;
    phone: string;
    role: string;
    createdAt: Date;
    branchId: string | null;
    [key: string]: unknown;
  }) {
    const { password: _password, ...rest } = user;
    return rest;
  }
}
