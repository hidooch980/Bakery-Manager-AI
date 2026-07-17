import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProfitDashboardService {

constructor(private prisma:PrismaService){}

async get(){

 const sales=0;
 const cost=0;

 return {
  totalSales:sales,
  totalCost:cost,
  profit:sales-cost
 };

}

}
