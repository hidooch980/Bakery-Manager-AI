import { Injectable } from '@nestjs/common';
import { CreateProductionStandardDto } from './dto/create-production-standard.dto';
import { UpdateProductionStandardDto } from './dto/update-production-standard.dto';

@Injectable()
export class ProductionStandardsService {
  create(createProductionStandardDto: CreateProductionStandardDto) {
    return 'This action adds a new productionStandard';
  }

  findAll() {
    return `This action returns all productionStandards`;
  }

  findOne(id: number) {
    return `This action returns a #${id} productionStandard`;
  }

  update(id: number, updateProductionStandardDto: UpdateProductionStandardDto) {
    return `This action updates a #${id} productionStandard`;
  }

  remove(id: number) {
    return `This action removes a #${id} productionStandard`;
  }
}
