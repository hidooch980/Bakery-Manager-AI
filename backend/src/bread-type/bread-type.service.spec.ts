import { Test, TestingModule } from '@nestjs/testing';
import { BreadTypeService } from './bread-type.service';

describe('BreadTypeService', () => {
  let service: BreadTypeService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [BreadTypeService],
    }).compile();

    service = module.get<BreadTypeService>(BreadTypeService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
