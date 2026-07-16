/*
  Warnings:

  - Added the required column `shift` to the `ProductionBatch` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "public"."ProductionBatch" ADD COLUMN     "shift" TEXT NOT NULL;
