import { Controller, Get } from '@nestjs/common';
import { AiAdvisorService } from './ai-advisor.service';

@Controller('ai-advisor')
export class AiAdvisorController {
  constructor(private service: AiAdvisorService) {}

  @Get()
  analyze() {
    return this.service.analyze();
  }
}
