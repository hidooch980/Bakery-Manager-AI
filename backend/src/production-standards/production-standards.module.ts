import { Module } from '@nestjs/common';
import { ProductionStandardsService } from './production-standards.service';
import { ProductionStandardsController } from './production-standards.controller';

@Module({
  controllers: [ProductionStandardsController],
  providers: [ProductionStandardsService],
})
export class ProductionStandardsModule {}
