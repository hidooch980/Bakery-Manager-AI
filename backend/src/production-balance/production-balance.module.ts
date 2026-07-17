import { PrismaModule } from '../prisma/prisma.module';
import { Module } from '@nestjs/common';
import { ProductionBalanceController } from './production-balance.controller';
import { ProductionBalanceService } from './production-balance.service';

@Module({
 imports: [PrismaModule],
  controllers: [ProductionBalanceController,ProductionBalanceController],
  providers: [ProductionBalanceService,ProductionBalanceService]
})
export class ProductionBalanceModule {}
