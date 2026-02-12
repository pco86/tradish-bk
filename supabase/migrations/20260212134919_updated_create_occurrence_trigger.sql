drop trigger if exists "create_occurrences_new_tradition" on "public"."tradition_date_rules";

drop function if exists "public"."execute_webhook_with_secret"();

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.excute_add_occurrences_new_tradition()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    webhook_url TEXT;
    api_key TEXT;
    -- Define other variables if needed
BEGIN
    -- Retrieve the secret values from the vault.decrypted_secrets view
    SELECT decrypted_secret INTO webhook_url FROM vault.decrypted_secrets WHERE name = 'add_occurrences_new_tradition';
    SELECT decrypted_secret INTO api_key FROM vault.decrypted_secrets WHERE name = 'webhook_secret';

    IF webhook_url is null then
        return null;
    end if;

    if api_key is null then
        return null;
    end if;

    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    PERFORM net.http_post(
        url := webhook_url,
        body := to_jsonb(NEW),
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'X-Webhook-Secret', 'Bearer ' || api_key
        )
    );

    RETURN NEW;
END;
$function$
;

CREATE TRIGGER add_occurrences_new_tradition AFTER INSERT ON public.tradition_date_rules FOR EACH ROW EXECUTE FUNCTION public.excute_add_occurrences_new_tradition();


