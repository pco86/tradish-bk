alter table "public"."traditions" add column "operations" jsonb not null;

alter table "public"."traditions" add constraint "default_tradition_operations_zero" CHECK (((NOT is_default) OR (operations = NULL::jsonb))) not valid;

alter table "public"."traditions" validate constraint "default_tradition_operations_zero";


