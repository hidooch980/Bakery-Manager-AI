import { Module } from '@nestjs/common';
import { SellerDebtService } from './seller-debt.service';
import { SellerDebtController } from './seller-debt.controller';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [SellerDebtService],
  controllers: [SellerDebtController],
  exports: [SellerDebtService],
})
export class SellerDebtModule {}
