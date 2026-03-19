alter table "public"."user_traditions" drop constraint "user_traditions_tradition_id_fkey";

alter table "public"."user_traditions" add constraint "user_traditions_tradition_id_fkey" FOREIGN KEY (tradition_id) REFERENCES public.traditions(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED not valid;

alter table "public"."user_traditions" validate constraint "user_traditions_tradition_id_fkey";


