import { Module } from '@nestjs/common';
import { ProductionController } from './production.controller';
import { ProductionControlController } from './production-control.controller';
import { ProductionService } from './production.service';
import { ProductionControlService } from './production-control.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [ProductionController, ProductionControlController],
  providers: [ProductionService, ProductionControlService],
  exports: [ProductionService],
})
export class ProductionModule {}
