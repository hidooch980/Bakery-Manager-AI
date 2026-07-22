-- CreateTable
CREATE TABLE "ProductionBalance" (
    "id" TEXT NOT NULL,
    "flourUsed" DOUBLE PRECISION NOT NULL,
    "breadType" TEXT NOT NULL,
    "saleCount" INTEGER NOT NULL,
    "saleWeight" DOUBLE PRECISION NOT NULL,
    "naninoWeight" DOUBLE PRECISION NOT NULL,
    "naninoConsumption" DOUBLE PRECISION NOT NULL,
    "balance" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ProductionBalance_pkey" PRIMARY KEY ("id")
);
