import { Test, TestingModule } from '@nestjs/testing';
import { FinancialReportController } from './financial-report.controller';

describe('FinancialReportController', () => {
  let controller: FinancialReportController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [FinancialReportController],
    }).compile();

    controller = module.get<FinancialReportController>(FinancialReportController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
