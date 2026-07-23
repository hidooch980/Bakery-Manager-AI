import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Put,
  Query,
} from '@nestjs/common';
import { CafeRestaurantService } from './cafe-restaurant.service';
import { CreateCafeOrderDto } from './dto/create-cafe-order.dto';

@Controller('cafe')
export class CafeRestaurantController {
  constructor(private readonly service: CafeRestaurantService) {}

  // ---------- دسته‌بندی منو ----------

  @Post('categories')
  createCategory(@Body() body: { name: string; sortOrder?: number }) {
    return this.service.createCategory(body);
  }

  @Get('categories')
  findCategories() {
    return this.service.findCategories();
  }

  @Put('categories/:id')
  updateCategory(
    @Param('id') id: string,
    @Body() body: { name?: string; sortOrder?: number; active?: boolean },
  ) {
    return this.service.updateCategory(id, body);
  }

  // ---------- آیتم‌های منو ----------

  @Post('menu-items')
  createMenuItem(
    @Body()
    body: {
      name: string;
      price: number;
      costPrice?: number;
      categoryId: string;
    },
  ) {
    return this.service.createMenuItem(body);
  }

  @Get('menu-items')
  findMenuItems() {
    return this.service.findMenuItems();
  }

  @Put('menu-items/:id')
  updateMenuItem(
    @Param('id') id: string,
    @Body()
    body: {
      name?: string;
      price?: number;
      costPrice?: number;
      available?: boolean;
      categoryId?: string;
    },
  ) {
    return this.service.updateMenuItem(id, body);
  }

  // ---------- میزها ----------

  @Post('tables')
  createTable(@Body() body: { name: string; capacity?: number }) {
    return this.service.createTable(body);
  }

  @Get('tables')
  findTables() {
    return this.service.findTables();
  }

  @Put('tables/:id')
  updateTable(
    @Param('id') id: string,
    @Body() body: { name?: string; capacity?: number; active?: boolean },
  ) {
    return this.service.updateTable(id, body);
  }

  // ---------- سفارش‌ها ----------

  @Post('orders')
  createOrder(@Body() dto: CreateCafeOrderDto) {
    return this.service.createOrder(dto);
  }

  @Get('orders')
  findOrders(@Query('status') status?: string) {
    return this.service.findOrders(status);
  }

  @Get('orders/:id')
  findOrder(@Param('id') id: string) {
    return this.service.findOrder(id);
  }

  @Patch('orders/:id/status')
  updateStatus(@Param('id') id: string, @Body('status') status: string) {
    return this.service.updateStatus(id, status);
  }

  @Patch('orders/:id/pay')
  payOrder(
    @Param('id') id: string,
    @Body('paymentMethod') paymentMethod: string,
  ) {
    return this.service.payOrder(id, paymentMethod);
  }

  // ---------- گزارش روز ----------

  @Get('summary')
  summary() {
    return this.service.summary();
  }
}
