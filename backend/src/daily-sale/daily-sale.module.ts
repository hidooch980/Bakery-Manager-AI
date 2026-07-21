import { Module } from '@nestjs/common';
import { DailySaleController } from './daily-sale.controller';
import { DailySaleService } from './daily-sale.service';
import { PrismaModule } from '../prisma/prisma.module';
import { DocumentSequenceModule } from '../document-sequence/document-sequence.module';

@Module({
  imports: [PrismaModule, DocumentSequenceModule],
  controllers: [DailySaleController],
  providers: [DailySaleService],
})
export class DailySaleModule {}
