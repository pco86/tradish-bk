-- 1. Create the custom enum type (if it doesn't exist)
DO $$
BEGIN
    IF NOT EXISTS(
        SELECT
            1
        FROM
            pg_type
        WHERE
            typname = 'rule_status') THEN
    CREATE TYPE rule_status AS ENUM(
        'active',
        'inactive',
        'draft'
);
END IF;
END
$$;

-- 2. Add the column to the table
ALTER TABLE event_date_rules
    ADD COLUMN status rule_status NOT NULL DEFAULT 'draft';
