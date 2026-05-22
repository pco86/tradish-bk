CREATE TABLE event_date_rules(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id uuid NOT NULL UNIQUE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    rule_type text CHECK (rule_type IN ('fixed', 'relative',
	'computed', 'weekly')),
    ALGORITHM text CHECK (ALGORITHM IN ('easter-western')),
    frequency text CHECK (frequency IN ('weekly', 'monthly', 'yearly')),
    calendar_type text CHECK (calendar_type IN ('gregorian', 'lunar',
	'hebrew', 'islamic', 'chinese')) DEFAULT
	'gregorian',
    relative_event_id uuid,
    FOREIGN KEY (relative_event_id) REFERENCES events(id),
    config jsonb,
    status text CHECK (status IN ('active', 'inactive',
	'draft')) NOT NULL DEFAULT 'draft',
    created_at timestamptz NOT NULL DEFAULT NOW(),
    updated_at timestamptz NOT NULL DEFAULT NOW()
);

ALTER TABLE event_date_rules
    ADD CONSTRAINT relative_frequency_null_check CHECK ((rule_type =
	'relative' AND frequency IS NULL) OR (rule_type <> 'relative'
	AND frequency IS NOT NULL));

ALTER TABLE public.event_date_rules ENABLE ROW LEVEL SECURITY;

-- TODO: Add a contraint that if relative frequency = relative_event_id.frequency
-- Policies for Event Date Rules
CREATE POLICY "Date Rules are viewable for events that can be seen" ON event_date_rules
    FOR SELECT TO authenticated, anon
    USING (EXISTS (
        SELECT
            1
        FROM
            events
        WHERE
            events.id = event_date_rules.event_id));

CREATE POLICY "Users can create date rules on events they own" ON event_date_rules
    FOR INSERT TO authenticated
    WITH CHECK (EXISTS (
        SELECT
            1
        FROM
            events
        WHERE (
            SELECT
                auth.uid()) = events.user_id
                AND events.id = event_date_rules.event_id));

CREATE POLICY "Creators can update their date rules" ON event_date_rules
    FOR UPDATE TO authenticated
    USING (EXISTS (
        SELECT
            1
        FROM
            events
        WHERE (
            SELECT
                auth.uid()) = events.user_id
                AND events.id = event_date_rules.event_id))
    WITH CHECK (EXISTS (
        SELECT
            1
        FROM
            events
        WHERE (
            SELECT
                auth.uid()) = events.user_id
                AND events.id = event_date_rules.event_id));

CREATE POLICY "Users can delete their date rules" ON event_date_rules
    FOR DELETE TO authenticated
    USING (EXISTS (
        SELECT
            1
        FROM
            events
        WHERE (
            SELECT
                auth.uid()) = events.user_id
                AND events.id = event_date_rules.event_id));
