alter table "public"."event_date_rules" add constraint "relative_frequency_null_check" CHECK ((((rule_type = 'relative'::text) AND (frequency IS NULL)) OR ((rule_type <> 'relative'::text) AND (frequency IS NOT NULL)))) not valid;

alter table "public"."event_date_rules" validate constraint "relative_frequency_null_check";


