-- CreateTable
CREATE TABLE "public"."ProfitDashboard" (
    "id" TEXT NOT NULL,
    "totalSales" DOUBLE PRECISION NOT NULL,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "profit" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProfitDashboard_pkey" PRIMARY KEY ("id")
);
