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


