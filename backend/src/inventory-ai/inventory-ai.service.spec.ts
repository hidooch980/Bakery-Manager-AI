import { Test, TestingModule } from '@nestjs/testing';
import { InventoryAiService } from './inventory-ai.service';

describe('InventoryAiService', () => {
  let service: InventoryAiService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [InventoryAiService],
    }).compile();

    service = module.get<InventoryAiService>(InventoryAiService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
