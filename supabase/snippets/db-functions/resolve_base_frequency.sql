CREATE OR REPLACE FUNCTION resolve_base_frequency(p_event_id uuid)
RETURNS text
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    current_event_id uuid := p_event_id;
    current_rule_type text;
    current_frequency text;
    next_event_id uuid;
    visited uuid[] := ARRAY[]::uuid[];
BEGIN
    LOOP
        -- Detect cycle
        IF current_event_id = ANY(visited) THEN
            RAISE EXCEPTION
                'Cycle detected in event_date_rules starting at event_id %',
                p_event_id;
        END IF;

        -- Mark as visited
        visited := array_append(visited, current_event_id);

        -- Fetch rule
        SELECT
            rule_type,
            frequency,
            relative_event_id
        INTO
            current_rule_type,
            current_frequency,
            next_event_id
        FROM event_date_rules
        WHERE event_id = current_event_id;

        IF NOT FOUND THEN
            RAISE EXCEPTION
                'No event_date_rule found for event_id %',
                current_event_id;
        END IF;

        -- If base rule, return frequency
        IF current_rule_type <> 'relative' THEN
            RETURN current_frequency;
        END IF;

        -- Otherwise move up the chain
        current_event_id := next_event_id;

        IF current_event_id IS NULL THEN
            RAISE EXCEPTION
                'Relative rule for event_id % has NULL relative_event_id',
                p_event_id;
        END IF;
    END LOOP;
END;
$$;