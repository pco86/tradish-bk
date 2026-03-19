alter table "public"."traditions" add column "notes" text;

alter table "public"."user_traditions" drop column "custom_title";

alter table "public"."user_traditions" drop column "is_favorite";

alter table "public"."user_traditions" drop column "notes";

alter table "public"."user_traditions" add column "parent_tradition_id" uuid;

alter table "public"."user_traditions" add constraint "user_traditions_parent_tradition_id_fkey" FOREIGN KEY (parent_tradition_id) REFERENCES public.traditions(id) ON DELETE CASCADE not valid;

alter table "public"."user_traditions" validate constraint "user_traditions_parent_tradition_id_fkey";


