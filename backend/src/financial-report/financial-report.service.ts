import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import moment from 'jalali-moment';

@Injectable()
export class FinancialReportService {
  constructor(private prisma: PrismaService) {}

  async monthly(year: number) {
    const months = [
      'فروردین',
      'اردیبهشت',
      'خرداد',
      'تیر',
      'مرداد',
      'شهریور',
      'مهر',
      'آبان',
      'آذر',
      'دی',
      'بهمن',
      'اسفند',
    ];

    const report: any[] = [];

    for (let i = 1; i <= 12; i++) {
      const start = moment(`${year}/${i}/1`, 'jYYYY/jM/jD')
        .startOf('day')
        .toDate();

      const end =
        i === 12
          ? moment(`${year + 1}/1/1`, 'jYYYY/jM/jD').toDate()
          : moment(`${year}/${i + 1}/1`, 'jYYYY/jM/jD').toDate();

      const sales = await this.prisma.sale.aggregate({
        _sum: {
          total: true,
          cashAmount: true,
          cardAmount: true,
        },
        where: {
          createdAt: {
            gte: start,
            lt: end,
          },
        },
      });

      const expenses = await this.prisma.expense.aggregate({
        _sum: {
          amount: true,
        },
        where: {
          createdAt: {
            gte: start,
            lt: end,
          },
        },
      });

      const productionCost = await this.prisma.productionCost.aggregate({
        _sum: {
          totalCost: true,
        },
        where: {
          createdAt: {
            gte: start,
            lt: end,
          },
        },
      });

      const flourSales = await this.prisma.flourSale.aggregate({
        _sum: {
          totalAmount: true,
        },
        where: {
          createdAt: {
            gte: start,
            lt: end,
          },
        },
      });

      const income = (sales._sum.total || 0) + (flourSales._sum.totalAmount || 0);

      const expense =
        (expenses._sum.amount || 0) + (productionCost._sum.totalCost || 0);

      report.push({
        month: months[i - 1],
        income,
        cash: sales._sum.cashAmount || 0,
        card: sales._sum.cardAmount || 0,
        flourSaleIncome: flourSales._sum.totalAmount || 0,
        expenses: expenses._sum.amount || 0,
        productionCost: productionCost._sum.totalCost || 0,
        profit: income - expense,
      });
    }

    return {
      year,
      fiscalYear: 'فروردین تا اسفند',
      months: report,
    };
  }

  async balanceSheet() {
    // --- دارایی‌ها (Assets) ---
    const latestCashbox = await this.prisma.cashBox.findFirst({
      orderBy: { createdAt: 'desc' },
    });
    const cash = latestCashbox?.balance || 0;

    const latestFlourInventory = await this.prisma.flourInventory.findFirst({
      orderBy: { createdAt: 'desc' },
    });
    const flourInventoryValue = latestFlourInventory
      ? (latestFlourInventory.closingStockBags || 0) *
        (latestFlourInventory.costPerBag || 0)
      : 0;

    const sellerDebts = await this.prisma.sellerDebt.findMany({
      where: { status: 'OPEN' },
    });
    const sellerReceivable = sellerDebts.reduce(
      (sum, d) => sum + (d.amount - d.paidAmount),
      0,
    );

    const employeeDebts = await this.prisma.debt.aggregate({
      _sum: { amount: true },
      where: { paid: false },
    });
    const employeeAdvances = await this.prisma.advance.aggregate({
      _sum: { amount: true },
    });
    const employeeReceivable =
      (employeeDebts._sum.amount || 0) + (employeeAdvances._sum.amount || 0);

    const totalAssets =
      cash + flourInventoryValue + sellerReceivable + employeeReceivable;

    // --- بدهی‌ها (Liabilities) ---
    const unpaidExpenses = await this.prisma.expense.aggregate({
      _sum: { amount: true },
      where: { paid: false },
    });

    const unpaidFlourPurchases = await this.prisma.flourPurchase.aggregate({
      _sum: { totalCost: true },
      where: { paid: false },
    });

    const unpaidSalaries = await this.prisma.salary.aggregate({
      _sum: { amount: true },
      where: { paid: false },
    });

    const totalLiabilities =
      (unpaidExpenses._sum.amount || 0) +
      (unpaidFlourPurchases._sum.totalCost || 0) +
      (unpaidSalaries._sum.amount || 0);

    const equity = totalAssets - totalLiabilities;

    return {
      assets: {
        cash,
        flourInventoryValue,
        sellerReceivable,
        employeeReceivable,
        total: totalAssets,
      },
      liabilities: {
        unpaidExpenses: unpaidExpenses._sum.amount || 0,
        unpaidFlourPurchases: unpaidFlourPurchases._sum.totalCost || 0,
        unpaidSalaries: unpaidSalaries._sum.amount || 0,
        total: totalLiabilities,
      },
      equity,
      note: 'ارزش موجودی سایر مواد اولیه (غیر از آرد) به دلیل نبود قیمت واحد در انبار، در این محاسبه لحاظ نشده است.',
    };
  }
}
