import { Test, TestingModule } from '@nestjs/testing';
import { CashboxController } from './cashbox.controller';

describe('CashboxController', () => {
  let controller: CashboxController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [CashboxController],
    }).compile();

    controller = module.get<CashboxController>(CashboxController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
