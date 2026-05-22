drop index if exists "public"."one_default_tradition_per_event";

alter table "public"."traditions" alter column "is_default" set default false;

alter table "public"."traditions" alter column "is_default" set not null;


