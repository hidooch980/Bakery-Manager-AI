import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { FlourSaleController } from './flour-sale.controller';
import { FlourSaleService } from './flour-sale.service';

@Module({
  imports: [PrismaModule],
  controllers: [FlourSaleController],
  providers: [FlourSaleService],
  exports: [FlourSaleService],
})
export class FlourSaleModule {}
