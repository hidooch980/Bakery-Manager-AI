import { Controller, Get } from '@nestjs/common';
import { InventoryAiService } from './inventory-ai.service';

@Controller('inventory-ai')
export class InventoryAiController {
  constructor(private readonly service: InventoryAiService) {}

  @Get('check')
  check() {
    return this.service.checkStock();
  }
}
