import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class FlourPurchaseService {
  constructor(
    private readonly prisma: PrismaService,
  ) {}

  async create(data: any) {

    const flour = await this.prisma.ingredient.findFirst({
      where: {
        name: 'آرد',
      },
    });

    if (!flour) {
      throw new Error('آرد در انبار تعریف نشده است');
    }

    const conversion = await this.prisma.unitConversion.findFirst({
      where: {
        ingredientId: flour.id,
        purchaseUnit: 'کیسه',
        baseUnit: 'کیلوگرم',
      },
    });


    const bagWeight = conversion
      ? conversion.conversionFactor
      : data.bagWeight || 40;


    const totalWeight = data.bags * bagWeight;


    const totalCost =
      (data.bags * data.pricePerBag) +
      (data.transportCost || 0) +
      (data.unloadingCost || 0);



    const purchase = await this.prisma.flourPurchase.create({
      data: {
        supplier: data.supplierName || data.supplier,
        bags: data.bags,
        weight: totalWeight,
        price: data.pricePerBag,
        transportCost: data.transportCost || 0,
        totalCost,
        note: data.note,
      },
    });



    await this.prisma.ingredient.update({
      where: {
        id: flour.id,
      },
      data: {
        quantity: {
          increment: totalWeight,
        },
      },
    });



    await this.prisma.inventoryTransaction.create({
      data: {
        ingredientId: flour.id,
        type: 'PURCHASE',
        quantity: totalWeight,
        description:
          `خرید ${data.bags} کیسه آرد (${totalWeight} کیلوگرم) از ${purchase.supplier}`,
      },
    });


    return {
      purchase,
      conversion: {
        bags: data.bags,
        bagWeight,
        totalWeight,
      },
    };
  }



  findAll() {
    return this.prisma.flourPurchase.findMany({
      orderBy: {
        createdAt: 'desc',
      },
    });
  }



  findOne(id:string) {
    return this.prisma.flourPurchase.findUnique({
      where:{
        id,
      },
    });
  }
}
