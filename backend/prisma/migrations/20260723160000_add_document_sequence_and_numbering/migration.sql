-- Create missing DocumentSequence table (referenced in code but never migrated)
CREATE TABLE IF NOT EXISTS "DocumentSequence" (
    "id" SERIAL NOT NULL,
    "document" TEXT NOT NULL,
    "prefix" TEXT NOT NULL DEFAULT '',
    "currentNo" INTEGER NOT NULL DEFAULT 1,
    "digits" INTEGER NOT NULL DEFAULT 6,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    CONSTRAINT "DocumentSequence_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX IF NOT EXISTS "DocumentSequence_document_key" ON "DocumentSequence"("document");

-- Add missing expenseNo column to Expense (referenced in code but never migrated)
ALTER TABLE "Expense" ADD COLUMN IF NOT EXISTS "expenseNo" TEXT;
UPDATE "Expense" SET "expenseNo" = 'EXP-' || substr(md5(random()::text || "id"), 1, 8) WHERE "expenseNo" IS NULL;
ALTER TABLE "Expense" ALTER COLUMN "expenseNo" SET NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS "Expense_expenseNo_key" ON "Expense"("expenseNo");

-- Add missing productionNo column to ProductionBatch (referenced in code but never migrated)
ALTER TABLE "ProductionBatch" ADD COLUMN IF NOT EXISTS "productionNo" TEXT;
UPDATE "ProductionBatch" SET "productionNo" = 'PRD-' || substr(md5(random()::text || "id"), 1, 8) WHERE "productionNo" IS NULL;
ALTER TABLE "ProductionBatch" ALTER COLUMN "productionNo" SET NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS "ProductionBatch_productionNo_key" ON "ProductionBatch"("productionNo");
