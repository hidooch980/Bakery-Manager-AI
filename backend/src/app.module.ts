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
import { SalesProfitModule } from './sales-profit/sales-profit.module';
import { DashboardModule } from './dashboard/dashboard.module';
import { ProductionAiModule } from './production-ai/production-ai.module';
import { BakerySettingsModule } from './bakery-settings/bakery-settings.module';
import { FlourControlModule } from './flour-control/flour-control.module';

@Module({
  imports: [PrismaModule, ProductsModule, InventoryModule, MaterialsModule, ProductionModule, IngredientsModule, CashboxModule, ExpensesModule, SalesModule, ReportsModule, AiModule, InventoryAiModule, EmployeesModule, FinancialModule, CostAnalysisModule, SalesProfitModule, DashboardModule, ProductionAiModule, BakerySettingsModule, FlourControlModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
