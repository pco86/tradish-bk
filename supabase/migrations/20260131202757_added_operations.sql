alter table "public"."tradition_date_rules" add column "operations" text[];

alter table "public"."tradition_date_rules" add column "rule_type" text;

alter table "public"."tradition_date_rules" add constraint "tradition_date_rules_rule_type_check" CHECK ((rule_type = ANY (ARRAY['fixed'::text, 'relative'::text, 'computed'::text, 'weekly'::text]))) not valid;

alter table "public"."tradition_date_rules" validate constraint "tradition_date_rules_rule_type_check";


