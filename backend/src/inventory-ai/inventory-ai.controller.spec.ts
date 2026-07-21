import { Test, TestingModule } from '@nestjs/testing';
import { InventoryAiController } from './inventory-ai.controller';

describe('InventoryAiController', () => {
  let controller: InventoryAiController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [InventoryAiController],
    }).compile();

    controller = module.get<InventoryAiController>(InventoryAiController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
