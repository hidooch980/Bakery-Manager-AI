import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
} from '@nestjs/common';
import { ProductionStandardsService } from './production-standards.service';
import { CreateProductionStandardDto } from './dto/create-production-standard.dto';
import { UpdateProductionStandardDto } from './dto/update-production-standard.dto';

@Controller('production-standards')
export class ProductionStandardsController {
  constructor(
    private readonly productionStandardsService: ProductionStandardsService,
  ) {}

  @Post()
  create(@Body() createProductionStandardDto: CreateProductionStandardDto) {
    return this.productionStandardsService.create(createProductionStandardDto);
  }

  @Get()
  findAll() {
    return this.productionStandardsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.productionStandardsService.findOne(+id);
  }

  @Patch(':id')
  update(
    @Param('id') id: string,
    @Body() updateProductionStandardDto: UpdateProductionStandardDto,
  ) {
    return this.productionStandardsService.update(
      +id,
      updateProductionStandardDto,
    );
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.productionStandardsService.remove(+id);
  }
}
