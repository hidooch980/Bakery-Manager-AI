import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { InventoryAiController } from './inventory-ai.controller';
import { InventoryAiService } from './inventory-ai.service';

@Module({
  imports: [PrismaModule],
  controllers: [InventoryAiController],
  providers: [InventoryAiService],
})
export class InventoryAiModule {}
