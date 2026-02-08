alter table "public"."tradition_date_rules" drop constraint "tradition_date_rules_rule_type_check";

alter table "public"."tradition_date_rules" add column "algorithm" text;

alter table "public"."tradition_date_rules" add constraint "tradition_date_rules_rule_type_check1" CHECK ((rule_type = 'easter_western'::text)) not valid;

alter table "public"."tradition_date_rules" validate constraint "tradition_date_rules_rule_type_check1";

alter table "public"."tradition_date_rules" add constraint "tradition_date_rules_rule_type_check" CHECK ((rule_type = ANY (ARRAY['fixed'::text, 'relative'::text, 'computed'::text, 'weekly'::text]))) not valid;

alter table "public"."tradition_date_rules" validate constraint "tradition_date_rules_rule_type_check";


