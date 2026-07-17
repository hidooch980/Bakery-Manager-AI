import { Module } from '@nestjs/common';
import { NaninoController } from './nanino.controller';
import { NaninoService } from './nanino.service';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [NaninoController],
  providers: [NaninoService],
})
export class NaninoModule {}
