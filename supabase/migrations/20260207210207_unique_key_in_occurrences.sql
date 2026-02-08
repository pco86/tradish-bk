CREATE UNIQUE INDEX tradition_occurrences_tradition_id_occurs_on_key ON public.tradition_occurrences USING btree (tradition_id, occurs_on);

alter table "public"."tradition_occurrences" add constraint "tradition_occurrences_tradition_id_occurs_on_key" UNIQUE using index "tradition_occurrences_tradition_id_occurs_on_key";


