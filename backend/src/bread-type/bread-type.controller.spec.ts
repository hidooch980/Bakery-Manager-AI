import { Test, TestingModule } from '@nestjs/testing';
import { BreadTypeController } from './bread-type.controller';

describe('BreadTypeController', () => {
  let controller: BreadTypeController;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [BreadTypeController],
    }).compile();

    controller = module.get<BreadTypeController>(BreadTypeController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
