import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';
import { CafeRestaurantController } from './cafe-restaurant.controller';
import { CafeRestaurantService } from './cafe-restaurant.service';

@Module({
  imports: [PrismaModule],
  controllers: [CafeRestaurantController],
  providers: [CafeRestaurantService],
})
export class CafeRestaurantModule {}
