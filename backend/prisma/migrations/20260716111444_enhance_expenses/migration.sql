-- AlterTable
ALTER TABLE "public"."Expense" ADD COLUMN     "category" TEXT,
ADD COLUMN     "month" TEXT,
ADD COLUMN     "note" TEXT,
ADD COLUMN     "paid" BOOLEAN NOT NULL DEFAULT false;
