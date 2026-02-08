CREATE UNIQUE INDEX tradition_date_rules_tradition_id_key ON public.tradition_date_rules USING btree (tradition_id);

alter table "public"."tradition_date_rules" add constraint "tradition_date_rules_tradition_id_key" UNIQUE using index "tradition_date_rules_tradition_id_key";


