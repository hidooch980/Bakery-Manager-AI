-- CreateTable
CREATE TABLE "public"."FlourPurchase" (
    "id" TEXT NOT NULL,
    "supplier" TEXT NOT NULL,
    "bags" DOUBLE PRECISION NOT NULL,
    "weight" DOUBLE PRECISION NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "transportCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "totalCost" DOUBLE PRECISION NOT NULL,
    "paid" BOOLEAN NOT NULL DEFAULT false,
    "note" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "FlourPurchase_pkey" PRIMARY KEY ("id")
);
