import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { BreadTypeController } from './bread-type.controller';
import { BreadTypeService } from './bread-type.service';

@Module({
  imports: [PrismaModule],
  controllers: [BreadTypeController],
  providers: [BreadTypeService]
})
export class BreadTypeModule {}
