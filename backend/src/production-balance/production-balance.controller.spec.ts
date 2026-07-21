import { Test, TestingModule } from '@nestjs/testing';
import { ProductionBalanceController } from './production-balance.controller';

describe('ProductionBalanceController', () => {
  let controller: ProductionBalanceController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ProductionBalanceController],
    }).compile();

    controller = module.get<ProductionBalanceController>(
      ProductionBalanceController,
    );
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
