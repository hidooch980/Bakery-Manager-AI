import { Module } from '@nestjs/common';
import { BakerySettingsController } from './bakery-settings.controller';
import { BakerySettingsService } from './bakery-settings.service';

@Module({
  controllers: [BakerySettingsController],
  providers: [BakerySettingsService]
})
export class BakerySettingsModule {}
