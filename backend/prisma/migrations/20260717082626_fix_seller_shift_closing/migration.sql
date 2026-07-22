-- AlterTable
ALTER TABLE "SellerShift" ADD COLUMN     "closingNote" TEXT,
ADD COLUMN     "settled" BOOLEAN NOT NULL DEFAULT false;
