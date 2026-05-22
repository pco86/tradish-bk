alter table "public"."traditions"
drop constraint "traditions_parent_tradition_id_fkey";

alter table "public"."traditions"
drop column "parent_tradition_id";

alter table "public"."traditions"
add column "is_default" boolean;

alter table "public"."traditions"
add column "operations" text[];

alter table "public"."traditions"
alter column "relative_event_id"
set not null;