import { PartialType } from '@nestjs/mapped-types';
import { CreateProductionCostDto } from './create-production-cost.dto';

export class UpdateProductionCostDto extends PartialType(CreateProductionCostDto) {}
