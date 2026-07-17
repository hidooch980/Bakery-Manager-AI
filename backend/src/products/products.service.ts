import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class ProductsService {
  constructor(private prisma: PrismaService) {}

  findAll() {
    return this.prisma.product.findMany({
      include:{category:true}
    });
  }

  create(data:any){ if(!data) data={};
    return this.prisma.product.create({data});
  }
}
