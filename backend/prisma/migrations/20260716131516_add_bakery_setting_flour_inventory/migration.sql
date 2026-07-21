-- CreateTable
CREATE TABLE "public"."BakerySetting" (
    "id" TEXT NOT NULL,
    "bakeryName" TEXT NOT NULL,
    "breadType" TEXT,
    "sellingDoughWeight" DOUBLE PRECISION NOT NULL DEFAULT 0.85,
    "naninoDoughWeight" DOUBLE PRECISION NOT NULL DEFAULT 0.85,
    "breadPrice" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "dailyCapacity" INTEGER NOT NULL DEFAULT 0,
    "standardWastePercent" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "workingStartTime" TEXT,
    "workingEndTime" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BakerySetting_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."FlourInventory" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "openingStockBags" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "factoryReceivedBags" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "purchasedBags" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "consumedBags" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "closingStockBags" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "bagWeight" DOUBLE PRECISION NOT NULL DEFAULT 40,
    "costPerBag" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "transportCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "unloadingCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "note" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "FlourInventory_pkey" PRIMARY KEY ("id")
);
