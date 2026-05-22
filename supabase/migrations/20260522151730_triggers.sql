set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.determine_rule_status(new_rule public.event_date_rules)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
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
$function$
;


