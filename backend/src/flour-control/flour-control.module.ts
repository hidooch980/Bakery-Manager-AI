import { Module } from '@nestjs/common';
import { FlourControlController } from './flour-control.controller';
import { FlourControlService } from './flour-control.service';

@Module({
  controllers: [FlourControlController],
  providers: [FlourControlService]
})
export class FlourControlModule {}
