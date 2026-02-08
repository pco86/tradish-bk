alter table "public"."tradition_date_rules" add column "frequency" text;

alter table "public"."tradition_date_rules" add constraint "tradition_date_rules_frequency_check" CHECK ((frequency = ANY (ARRAY['weekly'::text, 'monthly'::text, 'yearly'::text]))) not valid;

alter table "public"."tradition_date_rules" validate constraint "tradition_date_rules_frequency_check";


