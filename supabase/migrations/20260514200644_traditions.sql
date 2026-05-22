ALTER TABLE "public"."traditions"
    DROP CONSTRAINT "default_tradition_operations_zero";

ALTER TABLE "public"."traditions"
    DROP COLUMN "operations";
