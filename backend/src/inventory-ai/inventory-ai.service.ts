import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class InventoryAiService {
  constructor(private prisma: PrismaService) {}

  async checkStock() {

    const products = await this.prisma.product.findMany();

    const ingredients = await this.prisma.ingredient.findMany();

    const productAlerts = products.filter((p:any) => {
      return p.stock <= 5;
    });

    const ingredientAlerts = ingredients.filter((i:any) => {
      return i.quantity <= 5;
    });


    const totalItems =
      products.length + ingredients.length;

    const lowStockCount =
      productAlerts.length + ingredientAlerts.length;


    let status = 'NORMAL';

    if (lowStockCount > 0) {
      status = 'WARNING';
    }

    if (lowStockCount >= 5) {
      status = 'CRITICAL';
    }


    return {

      status,

      inventorySummary: {
        totalProducts: products.length,
        totalIngredients: ingredients.length,
        totalItems,
      },

      alerts: {
        products: productAlerts,
        ingredients: ingredientAlerts,
      },

      lowStockCount,

      aiRecommendation:
        lowStockCount > 0
        ? 'Purchase required for low stock items'
        : 'Inventory level is healthy',

      message:
        'AI inventory analysis completed'
    };
  }
}
