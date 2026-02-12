drop trigger if exists "hello_webhook" on "public"."traditions";

drop function if exists "public"."traditions_webhook_trigger"();

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.execute_webhook_with_secret()
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
    SELECT decrypted_secret INTO webhook_url FROM vault.decrypted_secrets WHERE name = 'webhook_url';
    SELECT decrypted_secret INTO api_key FROM vault.decrypted_secrets WHERE name = 'webhook_secret';

    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    PERFORM net.http_post(
        uri := webhook_url,
        body := to_jsonb(NEW),
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', 'Bearer ' || api_key
        )
    );

    RETURN NEW;
END;
$function$
;

CREATE TRIGGER hello_webhook AFTER INSERT ON public.traditions FOR EACH ROW EXECUTE FUNCTION public.execute_webhook_with_secret();


