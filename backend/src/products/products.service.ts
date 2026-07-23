import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProductsService {
  constructor(private prisma: PrismaService) {}

  findAll() {
    return this.prisma.product.findMany({
      include: { category: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  async create(data: any) {
    if (!data) data = {};

    let categoryId = data.categoryId;

    if (!categoryId) {
      // اگر دسته ارسال نشده، از دسته عمومی استفاده/ساخت می‌کنیم
      let defaultCategory = await this.prisma.category.findFirst({
        where: { name: 'عمومی' },
      });

      if (!defaultCategory) {
        defaultCategory = await this.prisma.category.create({
          data: { name: 'عمومی' },
        });
      }

      categoryId = defaultCategory.id;
    }

    return this.prisma.product.create({
      data: { ...data, categoryId },
    });
  }

  update(id: string, data: any) {
    return this.prisma.product.update({
      where: { id },
      data,
    });
  }

  remove(id: string) {
    return this.prisma.product.delete({ where: { id } });
  }
}
