drop trigger if exists "upsert_occurrences_update_tradition" on "public"."tradition_date_rules";

CREATE TRIGGER upsert_occurrences_update_tradition AFTER UPDATE ON public.traditions FOR EACH ROW EXECUTE FUNCTION public.excute_add_occurrences_new_tradition();


