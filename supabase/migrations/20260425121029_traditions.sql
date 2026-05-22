CREATE UNIQUE INDEX one_default_tradition_per_event ON public.traditions USING btree (event_id) WHERE (is_default = true);

alter table "public"."traditions" add constraint "default_tradition_operations_zero" CHECK (((NOT is_default) OR (operations = NULL::text[]))) not valid;

alter table "public"."traditions" validate constraint "default_tradition_operations_zero";


