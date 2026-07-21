import { CreateProductDto } from './dto/create-product.dto';
import { Controller, Get, Post, Body } from '@nestjs/common';
import { ProductsService } from './products.service';

@Controller('products')
export class ProductsController {
  constructor(private readonly service: ProductsService) {}

  @Get()
  findAll() {
    return this.service.findAll();
  }

  @Post()
  create(@Body() data: CreateProductDto) {
    return this.service.create(data);
  }
}
