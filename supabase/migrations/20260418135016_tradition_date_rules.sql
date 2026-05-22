alter table "public"."tradition_date_rules" drop constraint "tradition_date_rules_rule_type_check";

alter table "public"."tradition_date_rules" add column "relative_event_id" uuid;

alter table "public"."traditions" add column "relative_event_id" uuid;

alter table "public"."tradition_date_rules" add constraint "tradition_date_rules_relative_event_id_fkey" FOREIGN KEY (relative_event_id) REFERENCES public.events(id) not valid;

alter table "public"."tradition_date_rules" validate constraint "tradition_date_rules_relative_event_id_fkey";

alter table "public"."traditions" add constraint "traditions_relative_event_id_fkey" FOREIGN KEY (relative_event_id) REFERENCES public.events(id) ON DELETE SET NULL not valid;

alter table "public"."traditions" validate constraint "traditions_relative_event_id_fkey";

alter table "public"."tradition_date_rules" add constraint "tradition_date_rules_rule_type_check" CHECK ((rule_type = ANY (ARRAY['fixed'::text, 'relative'::text, 'computed'::text, 'weekly'::text, 'relative-event'::text]))) not valid;

alter table "public"."tradition_date_rules" validate constraint "tradition_date_rules_rule_type_check";


