import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class InventoryService {

  constructor(private prisma: PrismaService) {}

  findAll() {
    return this.prisma.ingredient.findMany({
      orderBy:{
        createdAt:'desc'
      }
    });
  }


  async create(data:any) {

    if(data.unit === 'کیلو' || data.unit === 'کیلوگرم'){
      data.unit = 'kg';
    }

    return this.prisma.ingredient.create({
      data
    });
  }


  async update(id:string,data:any) {

    const ingredient = await this.prisma.ingredient.findUnique({
      where:{id}
    });


    if(!ingredient){
      throw new NotFoundException('Ingredient not found');
    }


    if(data.quantity < 0){
      throw new BadRequestException('Quantity cannot be negative');
    }


    if(data.unit === 'کیلو' || data.unit === 'کیلوگرم'){
      data.unit = 'kg';
    }


    return this.prisma.ingredient.update({
      where:{id},
      data
    });

  }



  async mergeFlourInventory(){

    const flours = await this.prisma.ingredient.findMany({
      where:{
        name:'آرد'
      },
      orderBy:{
        createdAt:'asc'
      }
    });


    if(flours.length <= 1){
      return {
        message:'Already merged',
        count: flours.length
      };
    }


    const totalQuantity =
      flours.reduce(
        (sum,item)=> sum + item.quantity,
        0
      );


    const main = flours[0];


    await this.prisma.ingredient.update({
      where:{
        id:main.id
      },
      data:{
        quantity:totalQuantity,
        unit:'kg'
      }
    });


    const removeIds =
      flours
      .slice(1)
      .map(item=>item.id);


    await this.prisma.inventoryTransaction.deleteMany({ where:{ ingredientId:{ in:removeIds } } });
    await this.prisma.ingredient.deleteMany({
      where:{
        id:{
          in:removeIds
        }
      }
    });


    return {
      message:'Flour inventory merged',
      totalQuantity,
      removed:removeIds.length
    };

  }



  lowStock(){

    return this.prisma.ingredient.findMany({
      where:{
        quantity:{
          lte:0
        }
      }
    });

  }



  report(){

    return this.prisma.ingredient.aggregate({
      _sum:{
        quantity:true
      }
    });

  }

}
