import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DailySaleService {

  constructor(private prisma: PrismaService) {}

  async create(data: any) {

    const totalAmount =
      data.quantity * data.pricePerBread;

    return this.prisma.dailySale.create({
      data: {
        breadType: data.breadType,
        quantity: data.quantity,
        pricePerBread: data.pricePerBread,
        totalAmount,
        note: data.note || null
      }
    });
  }


  async findAll() {

    return this.prisma.dailySale.findMany({
      orderBy:{
        createdAt:'desc'
      }
    });

  }


  async today() {

    const start = new Date();
    start.setHours(0,0,0,0);

    const end = new Date();
    end.setHours(23,59,59,999);


    const sales = await this.prisma.dailySale.aggregate({
      _sum:{
        totalAmount:true,
        quantity:true
      },
      where:{
        createdAt:{
          gte:start,
          lte:end
        }
      }
    });


    return {
      breads: sales._sum.quantity || 0,
      amount: sales._sum.totalAmount || 0
    };
  }
}
