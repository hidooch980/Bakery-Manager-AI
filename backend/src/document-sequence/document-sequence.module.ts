import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { DocumentSequenceService } from './document-sequence.service';

@Module({
  imports: [PrismaModule],
  providers: [DocumentSequenceService],
  exports: [DocumentSequenceService],
})
export class DocumentSequenceModule {}
