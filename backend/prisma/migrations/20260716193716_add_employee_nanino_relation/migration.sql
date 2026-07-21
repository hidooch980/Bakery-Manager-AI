-- AddForeignKey
ALTER TABLE "public"."NaninoComparison" ADD CONSTRAINT "NaninoComparison_employeeId_fkey" FOREIGN KEY ("employeeId") REFERENCES "public"."Employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;
