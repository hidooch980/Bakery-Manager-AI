-- CreateTable
CREATE TABLE "public"."NaninoComparison" (
    "id" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "period" TEXT NOT NULL,
    "employeeId" TEXT,
    "sellingDoughCount" INTEGER NOT NULL DEFAULT 0,
    "naninoDoughCount" INTEGER NOT NULL DEFAULT 0,
    "difference" INTEGER NOT NULL DEFAULT 0,
    "sellingWeight" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "naninoWeight" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "weightDifference" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "note" TEXT,

    CONSTRAINT "NaninoComparison_pkey" PRIMARY KEY ("id")
);
