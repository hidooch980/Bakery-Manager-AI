import { Module } from '@nestjs/common';
import { ProductionAiController } from './production-ai.controller';
import { ProductionAiService } from './production-ai.service';

@Module({
  controllers: [ProductionAiController],
  providers: [ProductionAiService],
})
export class ProductionAiModule {}
