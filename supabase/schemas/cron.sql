CREATE FUNCTION schedule_occurrence_generation () RETURNS void LANGUAGE plpgsql SECURITY DEFINER -- Allows the function to run with the privileges of the user who created it (usually the database owner)
SET
    search_path = public AS $$ 
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
$$;

CREATE EXTENSION IF NOT EXISTS pg_cron;

SELECT
    cron.schedule (
        'schedule-materialization',
        '0 0 * * *',
        'SELECT public.schedule_occurrence_generation()'
    );