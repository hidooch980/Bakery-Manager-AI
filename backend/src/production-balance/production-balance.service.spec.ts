import { Test, TestingModule } from '@nestjs/testing';
import { ProductionBalanceService } from './production-balance.service';

describe('ProductionBalanceService', () => {
  let service: ProductionBalanceService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ProductionBalanceService],
    }).compile();

    service = module.get<ProductionBalanceService>(ProductionBalanceService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
