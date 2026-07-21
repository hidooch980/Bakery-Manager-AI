-- CreateTable
CREATE TABLE "SellerDebt" (
    "id" TEXT NOT NULL,
    "sellerId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "paidAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "status" TEXT NOT NULL DEFAULT 'OPEN',
    "note" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "paidAt" TIMESTAMP(3),
    "approvedBy" TEXT,
    "approvedAt" TIMESTAMP(3),

    CONSTRAINT "SellerDebt_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "SellerDebt" ADD CONSTRAINT "SellerDebt_sellerId_fkey" FOREIGN KEY ("sellerId") REFERENCES "Employee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
