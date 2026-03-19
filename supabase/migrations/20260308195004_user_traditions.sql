ALTER TABLE "public"."user_traditions"
DROP CONSTRAINT "user_traditions_tradition_id_fkey";

ALTER TABLE "public"."user_traditions"
ADD CONSTRAINT "user_traditions_tradition_id_fkey" FOREIGN KEY (tradition_id) REFERENCES public.traditions (id) ON DELETE CASCADE NOT VALID DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE "public"."user_traditions" VALIDATE CONSTRAINT "user_traditions_tradition_id_fkey";