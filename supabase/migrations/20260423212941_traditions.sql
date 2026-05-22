alter table "public"."traditions"
drop constraint "traditions_relative_event_id_fkey";

alter table "public"."traditions"
drop column "relative_event_id";

alter table "public"."traditions"
add column "event_id" uuid;

alter table "public"."traditions"
add constraint "traditions_event_id_fkey" FOREIGN KEY (event_id) REFERENCES public.events (id) ON DELETE SET NULL not valid;

alter table "public"."traditions" validate constraint "traditions_event_id_fkey";