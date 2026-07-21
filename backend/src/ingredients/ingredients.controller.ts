import { CreateIngredientDto } from './dto/create-ingredient.dto';
import { Controller, Get, Post, Body } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Controller('ingredients')
export class IngredientsController {
  constructor(private readonly prisma: PrismaService) {}

  @Get()
  findAll() {
    return this.prisma.ingredient.findMany({
      orderBy: {
        createdAt: 'desc',
      },
    });
  }

  @Post()
  create(@Body() data: CreateIngredientDto) {
    return this.prisma.ingredient.create({
      data,
    });
  }
}
