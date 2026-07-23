import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { DoughWeightControlController } from './dough-weight-control.controller';
import { DoughWeightControlService } from './dough-weight-control.service';

@Module({
  imports: [PrismaModule],
  controllers: [DoughWeightControlController],
  providers: [DoughWeightControlService],
})
export class DoughWeightControlModule {}
