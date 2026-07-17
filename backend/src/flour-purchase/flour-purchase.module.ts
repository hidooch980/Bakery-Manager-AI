import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { FlourPurchaseController } from './flour-purchase.controller';
import { FlourPurchaseService } from './flour-purchase.service';

@Module({
  imports: [PrismaModule],
  controllers: [FlourPurchaseController],
  providers: [FlourPurchaseService],
})
export class FlourPurchaseModule {}
