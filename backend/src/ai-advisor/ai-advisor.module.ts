import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { AiAdvisorController } from './ai-advisor.controller';
import { AiAdvisorService } from './ai-advisor.service';

@Module({
  imports: [PrismaModule],
  controllers: [AiAdvisorController],
  providers: [AiAdvisorService],
})
export class AiAdvisorModule {}
