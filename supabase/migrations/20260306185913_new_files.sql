set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.copy_steps_on_favorite()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    
    BEGIN
    INSERT INTO
        user_tradition_prep_steps(
            user_tradition_id,
            tradition_prep_step_id,
            sort_order
        )
    SELECT new.id, id, sort_order FROM tradition_prep_steps
    WHERE tradition_id = new.tradition_id;

    RETURN new;

END;
$function$
;

CREATE OR REPLACE FUNCTION public.excute_add_occurrences_new_tradition()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ 
DECLARE 
    webhook_url TEXT;
    api_key TEXT;
-- Define other variables if needed
BEGIN 
    -- Retrieve the secret values from the vault.decrypted_secrets view
    SELECT decrypted_secret INTO webhook_url FROM vault.decrypted_secrets
    WHERE name = 'add_occurrences_new_tradition';
    SELECT decrypted_secret INTO api_key FROM vault.decrypted_secrets
    WHERE name = 'webhook_secret';
    
    IF webhook_url IS NULL THEN 
        RETURN NULL;
    END IF;
    IF api_key IS NULL THEN 
        RETURN NULL;
    END IF;
    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    PERFORM net.http_post(
        url := webhook_url,
        body := to_jsonb(NEW),
        headers := jsonb_build_object(
            'Content-Type',
            'application/json',
            'X-Webhook-Secret',
            'Bearer ' || api_key
        )
    );
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.schedule_occurrence_generation()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$ 
DECLARE 
    webhook_url TEXT;
    api_key TEXT;
BEGIN -- Retrieve the secret values from the vault.decrypted_secrets view
    SELECT decrypted_secret INTO webhook_url FROM vault.decrypted_secrets 
    WHERE name = 'schedule_occurrence_generation';

    SELECT decrypted_secret INTO api_key FROM vault.decrypted_secrets
    WHERE name = 'webhook_secret';

    IF webhook_url IS NULL 
        THEN RETURN;
    END IF;

    IF api_key IS NULL 
        THEN RETURN;
    END IF;

    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    PERFORM net.http_post(
        url := webhook_url,
        headers := jsonb_build_object(
            'Content-Type',
            'application/json',
            'X-Webhook-Secret',
            'Bearer ' || api_key
        )
    );
END;
$function$
;

CREATE OR REPLACE FUNCTION public.set_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
    
    BEGIN new.updated_at = NOW();
    new.version = old.version + 1;
    RETURN new;

END;
$function$
;


