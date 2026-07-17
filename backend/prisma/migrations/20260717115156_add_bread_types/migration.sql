-- CreateTable
CREATE TABLE "BreadType" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "saleWeight" DOUBLE PRECISION NOT NULL,
    "naninoWeight" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BreadType_pkey" PRIMARY KEY ("id")
);
