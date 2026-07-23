import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateCafeOrderDto } from './dto/create-cafe-order.dto';

const OPEN_STATUSES = ['OPEN', 'PREPARING', 'SERVED'];
const ALL_STATUSES = ['OPEN', 'PREPARING', 'SERVED', 'PAID', 'CANCELED'];

@Injectable()
export class CafeRestaurantService {
  constructor(private readonly prisma: PrismaService) {}

  // ---------- دسته‌بندی منو ----------

  createCategory(data: { name: string; sortOrder?: number }) {
    if (!data?.name) {
      throw new BadRequestException('نام دسته‌بندی الزامی است');
    }
    return this.prisma.menuCategory.create({
      data: { name: data.name, sortOrder: Number(data.sortOrder) || 0 },
    });
  }

  findCategories() {
    return this.prisma.menuCategory.findMany({
      orderBy: { sortOrder: 'asc' },
      include: { items: { orderBy: { name: 'asc' } } },
    });
  }

  async updateCategory(
    id: string,
    data: { name?: string; sortOrder?: number; active?: boolean },
  ) {
    const category = await this.prisma.menuCategory.findUnique({
      where: { id },
    });
    if (!category) throw new NotFoundException('دسته‌بندی پیدا نشد');
    return this.prisma.menuCategory.update({ where: { id }, data });
  }

  // ---------- آیتم‌های منو ----------

  async createMenuItem(data: {
    name: string;
    price: number;
    costPrice?: number;
    categoryId: string;
  }) {
    if (!data?.name || !data?.categoryId) {
      throw new BadRequestException('نام و دسته‌بندی آیتم الزامی است');
    }
    const category = await this.prisma.menuCategory.findUnique({
      where: { id: data.categoryId },
    });
    if (!category) throw new NotFoundException('دسته‌بندی پیدا نشد');
    return this.prisma.menuItem.create({
      data: {
        name: data.name,
        price: Number(data.price) || 0,
        costPrice: Number(data.costPrice) || 0,
        categoryId: data.categoryId,
      },
    });
  }

  findMenuItems() {
    return this.prisma.menuItem.findMany({
      orderBy: { createdAt: 'desc' },
      include: { category: true },
    });
  }

  async updateMenuItem(
    id: string,
    data: {
      name?: string;
      price?: number;
      costPrice?: number;
      available?: boolean;
      categoryId?: string;
    },
  ) {
    const item = await this.prisma.menuItem.findUnique({ where: { id } });
    if (!item) throw new NotFoundException('آیتم منو پیدا نشد');
    return this.prisma.menuItem.update({ where: { id }, data });
  }

  // ---------- میزها ----------

  createTable(data: { name: string; capacity?: number }) {
    if (!data?.name) throw new BadRequestException('نام میز الزامی است');
    return this.prisma.diningTable.create({
      data: { name: data.name, capacity: Number(data.capacity) || 4 },
    });
  }

  async findTables() {
    const tables = await this.prisma.diningTable.findMany({
      orderBy: { name: 'asc' },
      include: {
        orders: {
          where: { status: { in: OPEN_STATUSES } },
          select: { id: true },
        },
      },
    });
    return tables.map(({ orders, ...table }) => ({
      ...table,
      busy: orders.length > 0,
    }));
  }

  async updateTable(
    id: string,
    data: { name?: string; capacity?: number; active?: boolean },
  ) {
    const table = await this.prisma.diningTable.findUnique({ where: { id } });
    if (!table) throw new NotFoundException('میز پیدا نشد');
    return this.prisma.diningTable.update({ where: { id }, data });
  }

  // ---------- سفارش‌ها ----------

  async createOrder(dto: CreateCafeOrderDto) {
    if (dto.type === 'DINE_IN' && !dto.tableId) {
      throw new BadRequestException(
        'برای سفارش داخل سالن انتخاب میز الزامی است',
      );
    }

    if (dto.tableId) {
      const table = await this.prisma.diningTable.findUnique({
        where: { id: dto.tableId },
      });
      if (!table) throw new NotFoundException('میز پیدا نشد');
    }

    const menuItemIds = dto.items.map((line) => line.menuItemId);
    const menuItems = await this.prisma.menuItem.findMany({
      where: { id: { in: menuItemIds } },
    });

    const byId = new Map<string, (typeof menuItems)[number]>();
    for (const menuItem of menuItems) byId.set(menuItem.id, menuItem);

    for (const line of dto.items) {
      const menuItem = byId.get(line.menuItemId);
      if (!menuItem) {
        throw new NotFoundException('آیتم منو پیدا نشد: ' + line.menuItemId);
      }
      if (!menuItem.available) {
        throw new BadRequestException(
          `آیتم «${menuItem.name}» در دسترس نیست`,
        );
      }
    }

    const subtotal = dto.items.reduce(
      (sum, line) => sum + byId.get(line.menuItemId)!.price * line.quantity,
      0,
    );
    const discount = Number(dto.discount) || 0;
    if (discount > subtotal) {
      throw new BadRequestException(
        'تخفیف نمی‌تواند بیشتر از مبلغ سفارش باشد',
      );
    }

    return this.prisma.cafeOrder.create({
      data: {
        type: dto.type,
        tableId: dto.tableId || null,
        customerName: dto.customerName || null,
        note: dto.note || null,
        discount,
        totalAmount: subtotal - discount,
        items: {
          create: dto.items.map((line) => ({
            menuItemId: line.menuItemId,
            quantity: line.quantity,
            unitPrice: byId.get(line.menuItemId)!.price,
          })),
        },
      },
      include: { items: { include: { menuItem: true } }, table: true },
    });
  }

  findOrders(status?: string) {
    return this.prisma.cafeOrder.findMany({
      where: status ? { status } : undefined,
      orderBy: { createdAt: 'desc' },
      take: 100,
      include: { items: { include: { menuItem: true } }, table: true },
    });
  }

  async findOrder(id: string) {
    const order = await this.prisma.cafeOrder.findUnique({
      where: { id },
      include: { items: { include: { menuItem: true } }, table: true },
    });
    if (!order) throw new NotFoundException('سفارش پیدا نشد');
    return order;
  }

  async updateStatus(id: string, status: string) {
    if (!ALL_STATUSES.includes(status)) {
      throw new BadRequestException('وضعیت نامعتبر است');
    }
    const order = await this.findOrder(id);
    if (order.status === 'PAID' || order.status === 'CANCELED') {
      throw new BadRequestException('سفارش بسته‌شده قابل تغییر نیست');
    }
    return this.prisma.cafeOrder.update({
      where: { id },
      data: {
        status,
        paidAt: status === 'PAID' ? new Date() : undefined,
      },
      include: { items: { include: { menuItem: true } }, table: true },
    });
  }

  async payOrder(id: string, paymentMethod: string) {
    if (!['CASH', 'CARD'].includes(paymentMethod)) {
      throw new BadRequestException('روش پرداخت نامعتبر است');
    }
    const order = await this.findOrder(id);
    if (order.status === 'PAID' || order.status === 'CANCELED') {
      throw new BadRequestException('سفارش بسته‌شده قابل تسویه نیست');
    }
    return this.prisma.cafeOrder.update({
      where: { id },
      data: { status: 'PAID', paymentMethod, paidAt: new Date() },
      include: { items: { include: { menuItem: true } }, table: true },
    });
  }

  // ---------- گزارش روز ----------

  async summary() {
    const startOfDay = new Date();
    startOfDay.setHours(0, 0, 0, 0);

    const [paidOrders, openCount, canceledCount] = await Promise.all([
      this.prisma.cafeOrder.findMany({
        where: { status: 'PAID', paidAt: { gte: startOfDay } },
      }),
      this.prisma.cafeOrder.count({
        where: { status: { in: OPEN_STATUSES } },
      }),
      this.prisma.cafeOrder.count({
        where: { status: 'CANCELED', updatedAt: { gte: startOfDay } },
      }),
    ]);

    return {
      date: startOfDay.toISOString(),
      revenue: paidOrders.reduce((sum, order) => sum + order.totalAmount, 0),
      paidCount: paidOrders.length,
      discountTotal: paidOrders.reduce((sum, order) => sum + order.discount, 0),
      openCount,
      canceledCount,
    };
  }
}
