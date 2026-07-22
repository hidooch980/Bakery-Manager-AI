-- AlterTable
ALTER TABLE "public"."Ingredient" ADD COLUMN     "minStock" DOUBLE PRECISION NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "public"."InventoryTransaction" ADD COLUMN     "minStock" DOUBLE PRECISION NOT NULL DEFAULT 0;
