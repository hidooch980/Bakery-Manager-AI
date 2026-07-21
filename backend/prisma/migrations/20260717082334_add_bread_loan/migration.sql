-- CreateTable
CREATE TABLE "BreadLoan" (
    "id" TEXT NOT NULL,
    "personName" TEXT NOT NULL,
    "breadCount" INTEGER NOT NULL,
    "breadPrice" DOUBLE PRECISION NOT NULL,
    "totalAmount" DOUBLE PRECISION NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'OPEN',
    "loanDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "returnDate" TIMESTAMP(3),
    "returned" INTEGER NOT NULL DEFAULT 0,
    "note" TEXT,

    CONSTRAINT "BreadLoan_pkey" PRIMARY KEY ("id")
);
