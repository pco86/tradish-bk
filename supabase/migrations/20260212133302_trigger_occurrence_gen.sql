drop trigger if exists "hello_webhook" on "public"."traditions";

CREATE TRIGGER create_occurrences_new_tradition AFTER INSERT ON public.tradition_date_rules FOR EACH ROW EXECUTE FUNCTION public.execute_webhook_with_secret();


