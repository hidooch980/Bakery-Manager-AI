import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { DocumentSequenceModule } from '../document-sequence/document-sequence.module';
import { CashboxController } from './cashbox.controller';
import { CashboxService } from './cashbox.service';

@Module({
  imports: [PrismaModule, DocumentSequenceModule],
  controllers: [CashboxController],
  providers: [CashboxService],
})
export class CashboxModule {}
