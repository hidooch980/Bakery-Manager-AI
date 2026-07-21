import { PartialType } from '@nestjs/mapped-types';
import { CreateProductionStandardDto } from './create-production-standard.dto';

export class UpdateProductionStandardDto extends PartialType(
  CreateProductionStandardDto,
) {}
