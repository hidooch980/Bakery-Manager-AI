-- CreateTable
CREATE TABLE "public"."SellerShift" (
    "id" TEXT NOT NULL,
    "employeeId" TEXT NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "endTime" TIMESTAMP(3),
    "breadReceived" INTEGER NOT NULL DEFAULT 0,
    "cashDelivered" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "cardDelivered" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "expectedAmount" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "difference" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "note" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SellerShift_pkey" PRIMARY KEY ("id")
);
