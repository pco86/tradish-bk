ALTER TABLE "public"."user_traditions"
DROP CONSTRAINT "user_traditions_parent_tradition_id_fkey";

ALTER TABLE "public"."user_traditions"
DROP COLUMN "parent_tradition_id";