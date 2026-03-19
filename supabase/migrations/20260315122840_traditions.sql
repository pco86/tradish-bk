ALTER TABLE "public"."traditions"
ADD COLUMN "parent_tradition_id" UUID;

ALTER TABLE "public"."traditions"
ADD CONSTRAINT "traditions_parent_tradition_id_fkey" FOREIGN KEY (parent_tradition_id) REFERENCES public.traditions (id) ON DELETE SET NULL NOT VALID;

ALTER TABLE "public"."traditions" VALIDATE CONSTRAINT "traditions_parent_tradition_id_fkey";

ALTER TABLE "public"."traditions"
DROP COLUMN "version";