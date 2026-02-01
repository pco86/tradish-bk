alter table "public"."tradition_date_rules" drop constraint "tradition_date_rules_rule_type_check";

alter table "public"."tradition_date_rules" add constraint "tradition_date_rules_rule_type_check" CHECK ((rule_type = ANY (ARRAY['fixed'::text, 'relative'::text, 'computed'::text, 'weekly'::text, 'easter'::text]))) not valid;

alter table "public"."tradition_date_rules" validate constraint "tradition_date_rules_rule_type_check";


