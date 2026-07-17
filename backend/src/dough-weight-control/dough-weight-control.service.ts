import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class DoughWeightControlService {
  constructor(private prisma: PrismaService) {}

  create(data:any){
    return this.prisma.doughWeightControl.create({
      data:{
        sellerWeight:data.sellerWeight,
        naninoWeight:data.naninoWeight,
        difference:data.sellerWeight - data.naninoWeight,
        breadCount:data.breadCount || 0,
        note:data.note
      }
    });
  }

  findAll(){
    return this.prisma.doughWeightControl.findMany({
      orderBy:{date:'desc'}
    });
  }
}
