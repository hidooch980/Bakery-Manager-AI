import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { ProductionCostService } from './production-cost.service';
import { ProductionCostController } from './production-cost.controller';

@Module({
  imports: [PrismaModule],
  controllers: [ProductionCostController],
  providers: [ProductionCostService],
})
export class ProductionCostModule {}
