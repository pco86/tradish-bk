alter table "public"."tradition_date_rules" add constraint "tradition_date_rules_algorithm_check" CHECK ((algorithm = 'easter_western'::text)) not valid;

alter table "public"."tradition_date_rules" validate constraint "tradition_date_rules_algorithm_check";


