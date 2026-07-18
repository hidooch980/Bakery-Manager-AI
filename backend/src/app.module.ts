import { UnitConversionModule } from './unit-conversion/unit-conversion.module';
import { ConfigModule } from '@nestjs/config';
import { AuthModule } from './auth/auth.module';
import { AiAdvisorModule } from './ai-advisor/ai-advisor.module';
import { DailyReportModule } from './daily-report/daily-report.module';
import { ProductionSalesControlModule } from './production-sales-control/production-sales-control.module';
import { SellerShiftModule } from './seller-shift/seller-shift.module';
import { NaninoModule } from './nanino/nanino.module';
import { DashboardModule } from './dashboard/dashboard.module';
import { SalesProfitModule } from './sales-profit/sales-profit.module';
import { ProfitDashboardModule } from './profit-dashboard/profit-dashboard.module';
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { ProductsModule } from './products/products.module';
import { InventoryModule } from './inventory/inventory.module';
import { MaterialsModule } from './materials/materials.module';
import { ProductionModule } from './production/production.module';
import { IngredientsModule } from './ingredients/ingredients.module';
import { CashboxModule } from './cashbox/cashbox.module';
import { ExpensesModule } from './expenses/expenses.module';
import { SalesModule } from './sales/sales.module';
import { ReportsModule } from './reports/reports.module';
import { AiModule } from './ai/ai.module';
import { InventoryAiModule } from './inventory-ai/inventory-ai.module';
import { EmployeesModule } from './employees/employees.module';
import { FinancialModule } from './financial/financial.module';
import { CostAnalysisModule } from './cost-analysis/cost-analysis.module';
import { ProductionAiModule } from './production-ai/production-ai.module';
import { BakerySettingsModule } from './bakery-settings/bakery-settings.module';
import { FlourControlModule } from './flour-control/flour-control.module';
import { FlourPurchaseModule } from './flour-purchase/flour-purchase.module';
import { ProductionCostModule } from './production-cost/production-cost.module';
import { BranchModule } from './branch/branch.module';
import { FinancialReportModule } from './financial-report/financial-report.module';
import { DailySaleModule } from './daily-sale/daily-sale.module';
import { SellerDebtModule } from './seller-debt/seller-debt.module';
import { NotificationModule } from './notification/notification.module';
import { BreadTypeModule } from './bread-type/bread-type.module';
import { ProductionBalanceModule } from './production-balance/production-balance.module';
import { AppVersionModule } from './app-version/app-version.module';
import { DeviceModule } from './device/device.module';

@Module({
  imports: [ProductionBalanceModule, ConfigModule.forRoot({ isGlobal: true }), AuthModule, NaninoModule, DashboardModule, SalesProfitModule,PrismaModule, ProductsModule, InventoryModule, MaterialsModule, ProductionModule, IngredientsModule, CashboxModule, ExpensesModule, SalesModule, ReportsModule, AiModule, InventoryAiModule, EmployeesModule, FinancialModule, CostAnalysisModule, SalesProfitModule, DashboardModule, ProductionAiModule, BakerySettingsModule, FlourControlModule, FlourPurchaseModule, ProductionCostModule, ProfitDashboardModule, SellerShiftModule, ProductionSalesControlModule, AiAdvisorModule, DailyReportModule, BranchModule, UnitConversionModule, FinancialReportModule, DailySaleModule, SellerDebtModule, NotificationModule, BreadTypeModule, ProductionBalanceModule, AppVersionModule, DeviceModule],
  providers: [AppService],
})
export class AppModule {}
