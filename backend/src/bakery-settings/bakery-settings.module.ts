import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { BakerySettingsController } from './bakery-settings.controller';
import { BakerySettingsService } from './bakery-settings.service';

@Module({
  imports: [PrismaModule],
  controllers: [BakerySettingsController],
  providers: [BakerySettingsService],
})
export class BakerySettingsModule {}
