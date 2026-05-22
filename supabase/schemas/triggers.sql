CREATE FUNCTION excute_add_occurrences_new_tradition()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    SECURITY DEFINER
    SET search_path = public
    AS $$
DECLARE
    webhook_url text;
    api_key text;
    -- Define other variables if needed
BEGIN
    -- Retrieve the secret values from the vault.decrypted_secrets view
    SELECT
        decrypted_secret
    INTO
        webhook_url
    FROM
        vault.decrypted_secrets
    WHERE
        name = 'add_occurrences_new_tradition';
    SELECT
        decrypted_secret
    INTO
        api_key
    FROM
        vault.decrypted_secrets
    WHERE
        name = 'webhook_secret';
    IF webhook_url IS NULL THEN
        RETURN NULL;
    END IF;
    IF api_key IS NULL THEN
        RETURN NULL;
    END IF;
    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    -- This triggers an edge function which creates the occurrences in the db.
    PERFORM
	net.http_post(url := webhook_url, body := to_jsonb(NEW), headers :=
	    jsonb_build_object('Content-Type', 'application/json', 'X-Webhook-Secret',
	    'Bearer ' || api_key));
    RETURN NEW;
END;
$$;

CREATE FUNCTION excute_add_occurrences_new_event()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    SECURITY DEFINER
    SET search_path = public
    AS $$
DECLARE
    webhook_url text;
    api_key text;
    -- Define other variables if needed
BEGIN
    -- Retrieve the secret values from the vault.decrypted_secrets view
    SELECT
        decrypted_secret
    INTO
        webhook_url
    FROM
        vault.decrypted_secrets
    WHERE
        name = 'add_occurrences_new_event';
    SELECT
        decrypted_secret
    INTO
        api_key
    FROM
        vault.decrypted_secrets
    WHERE
        name = 'webhook_secret';
    IF webhook_url IS NULL THEN
        RETURN NULL;
    END IF;
    IF api_key IS NULL THEN
        RETURN NULL;
    END IF;
    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    -- This triggers an edge function which creates the occurrences in the db.
    PERFORM
	net.http_post(url := webhook_url, body := to_jsonb(NEW), headers :=
	    jsonb_build_object('Content-Type', 'application/json',
	    'X-Webhook-Secret', 'Bearer ' || api_key));
    RETURN NEW;
END;
$$;

CREATE TRIGGER add_occurrences_new_tradition
    AFTER INSERT ON public.traditions
    FOR EACH ROW
    EXECUTE FUNCTION excute_add_occurrences_new_tradition();

CREATE TRIGGER add_occurrences_new_event
    AFTER INSERT ON public.event_date_rules
    FOR EACH ROW
    EXECUTE FUNCTION excute_add_occurrences_new_event();

CREATE TRIGGER upsert_occurrences_update_tradition
    AFTER UPDATE ON public.traditions
    FOR EACH ROW
    EXECUTE FUNCTION excute_add_occurrences_new_tradition();

CREATE TRIGGER upsert_occurrences_update_event
    AFTER UPDATE ON public.event_date_rules
    FOR EACH ROW
    EXECUTE FUNCTION excute_add_occurrences_new_event();

CREATE FUNCTION set_updated_at()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN new;
END;
$$;

CREATE TRIGGER traditions_updated
    BEFORE UPDATE ON traditions
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER events_updated
    BEFORE UPDATE ON events
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER event_date_operations_updated
    BEFORE UPDATE ON event_date_rule_operations
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER tradition_date_operations_updated
    BEFORE UPDATE ON tradition_date_rule_operations
    FOR EACH ROW
    EXECUTE FUNCTION set_updated_at();

-- TODO: ADD A TRIGGER PERHAPS?
CREATE FUNCTION copy_steps_on_favorite()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    SECURITY DEFINER
    AS $$
BEGIN
    INSERT INTO user_tradition_prep_steps(user_tradition_id,
	tradition_prep_step_id, sort_order)
    SELECT
        NEW.id,
        id,
        sort_order
    FROM
        tradition_prep_steps
    WHERE
        tradition_id = NEW.parent_tradition_id;
    RETURN new;
END;
$$;

-- CREATE TRIGGER copy_steps_trigger
-- AFTER INSERT ON user_traditions FOR EACH ROW
-- EXECUTE FUNCTION copy_steps_on_favorite ();
-- TODO: ADD A TRIGGER PERHAPS?
CREATE FUNCTION copy_tradition_on_favorite()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    SECURITY DEFINER
    AS $$
DECLARE
    new_id uuid;
BEGIN
    INSERT INTO traditions(user_id, title, short_description, long_description,
	notes, visibility)
    SELECT
        auth.uid(),
        title,
        short_description,
        long_description,
        notes,
        'private'
    FROM
        traditions
    WHERE
        id = NEW.parent_tradition_id
    RETURNING
        id
    INTO
        new_id;
    NEW.tradition_id := new_id;
    RETURN NEW;
END;
$$;

-- CREATE TRIGGER copy_tradition_trigger BEFORE INSERT ON user_traditions FOR EACH ROW
-- EXECUTE FUNCTION copy_tradition_on_favorite ();
-- Creates a user tradition when a user generates a tradition.
CREATE FUNCTION tradition_owner_user_tradition()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    SECURITY DEFINER
    AS $$
BEGIN
    IF auth.uid() IS NULL THEN
        RETURN NULL;
    END IF;
    INSERT INTO user_traditions(user_id, tradition_id)
        VALUES(auth.uid(), NEW.id);
    RETURN NEW;
END;
$$;

CREATE TRIGGER create_user_tradition
    AFTER INSERT ON traditions
    FOR EACH ROW
    EXECUTE FUNCTION tradition_owner_user_tradition();

CREATE OR REPLACE FUNCTION determine_rule_status(new_rule event_date_rules)
    RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    required text[];
    field text;
BEGIN
    -- Must have type
    IF new_rule.rule_type IS NULL THEN
        RETURN 'draft';
    END IF;
    -- Get required fields
    SELECT
        required_fields
    INTO
        required
    FROM
        rule_type_requirements
    WHERE
        rule_type = new_rule.rule_type;
    -- Unknown type
    IF required IS NULL THEN
        RETURN 'invalid';
    END IF;
    -- No required fields means structurally ready
    IF cardinality(required) = 0 THEN
        RETURN 'active';
    END IF;
    -- Ensure config exists
    IF new_rule.config IS NULL THEN
        RETURN 'draft';
    END IF;
    -- Check each required field
    FOREACH field IN ARRAY required LOOP
        IF NULLIF(BTRIM(new_rule.config ->> field), '') IS NULL THEN
            RETURN 'draft';
        END IF;
    END LOOP;
    RETURN 'active';
END;
$$;

CREATE OR REPLACE FUNCTION set_rule_status()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.status := determine_rule_status(NEW);
    RETURN NEW;
END;
$$;

CREATE TRIGGER rule_status_trigger
    BEFORE INSERT OR UPDATE ON event_date_rules
    FOR EACH ROW
    EXECUTE FUNCTION set_rule_status();
