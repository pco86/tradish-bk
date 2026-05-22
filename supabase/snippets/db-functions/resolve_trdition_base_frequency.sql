CREATE OR REPLACE FUNCTION resolve_tradition_base_frequency(p_tradition_id uuid)
RETURNS text
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_event_id uuid;
BEGIN
    -- Get the associated event
    SELECT event_id
    INTO v_event_id
    FROM traditions
    WHERE id = p_tradition_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION
            'No tradition found for id %',
            p_tradition_id;
    END IF;

    -- Delegate to event resolver
    RETURN resolve_base_frequency(v_event_id);
END;
$$;