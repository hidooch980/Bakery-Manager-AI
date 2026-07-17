import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { ProductionSalesControlController } from './production-sales-control.controller';
import { ProductionSalesControlService } from './production-sales-control.service';

@Module({
 imports:[PrismaModule],
 controllers:[ProductionSalesControlController],
 providers:[ProductionSalesControlService]
})
export class ProductionSalesControlModule {}
