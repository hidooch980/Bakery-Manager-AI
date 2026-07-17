import { Module } from '@nestjs/common';
import { DailySaleController } from './daily-sale.controller';
import { DailySaleService } from './daily-sale.service';
import { PrismaService } from '../prisma/prisma.service';

@Module({
  controllers:[
    DailySaleController
  ],
  providers:[
    DailySaleService,
    PrismaService
  ]
})
export class DailySaleModule {}
