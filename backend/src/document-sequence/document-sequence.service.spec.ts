import { Test, TestingModule } from '@nestjs/testing';
import { DocumentSequenceService } from './document-sequence.service';

describe('DocumentSequenceService', () => {
  let service: DocumentSequenceService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DocumentSequenceService],
    }).compile();

    service = module.get<DocumentSequenceService>(DocumentSequenceService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
