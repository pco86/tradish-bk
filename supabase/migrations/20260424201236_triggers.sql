drop trigger if exists "add_occurrences_new_tradition" on "public"."tradition_date_rules";

CREATE TRIGGER add_occurrences_new_tradition AFTER INSERT ON public.traditions FOR EACH ROW EXECUTE FUNCTION public.excute_add_occurrences_new_tradition();


