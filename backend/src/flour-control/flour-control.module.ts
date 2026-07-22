import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { FlourControlController } from './flour-control.controller';
import { FlourControlService } from './flour-control.service';

@Module({
  imports: [PrismaModule],
  controllers: [FlourControlController],
  providers: [FlourControlService],
})
export class FlourControlModule {}
