import { Module } from '@nestjs/common';
import { SellerShiftController } from './seller-shift.controller';
import { SellerShiftService } from './seller-shift.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [SellerShiftController],
  providers: [SellerShiftService],
})
export class SellerShiftModule {}
