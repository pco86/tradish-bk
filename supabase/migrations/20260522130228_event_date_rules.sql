alter table "public"."event_date_rules" add column "status" text not null default 'draft'::text;

drop type "public"."rule_status";

alter table "public"."event_date_rules" add constraint "event_date_rules_status_check" CHECK ((status = ANY (ARRAY['active'::text, 'inactive'::text, 'draft'::text]))) not valid;

alter table "public"."event_date_rules" validate constraint "event_date_rules_status_check";


