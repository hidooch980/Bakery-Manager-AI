-- CreateTable
CREATE TABLE "BakerySettings" (
    "id" TEXT NOT NULL,
    "saleWeights" JSONB NOT NULL,
    "naninoWeights" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BakerySettings_pkey" PRIMARY KEY ("id")
);
