CREATE TABLE
    event_date_rules (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        event_id UUID NOT NULL UNIQUE,
        FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE,
        rule_type TEXT CHECK (
            rule_type IN ('fixed', 'relative', 'computed', 'weekly')
        ),
        ALGORITHM TEXT CHECK (ALGORITHM IN ('easter-western')),
        frequency TEXT CHECK (frequency IN ('weekly', 'monthly', 'yearly')),
        operations TEXT[],
        calendar_type TEXT CHECK (
            calendar_type IN (
                'gregorian',
                'lunar',
                'hebrew',
                'islamic',
                'chinese'
            )
        ) DEFAULT 'gregorian',
        relative_event_id UUID,
        FOREIGN KEY (relative_event_id) REFERENCES events (id),
        month INTEGER,
        day INTEGER,
        weekday INTEGER,
        week_of_month INTEGER,
        interval INTEGER,
        created_at timestamptz NOT NULL DEFAULT NOW(),
        updated_at timestamptz NOT NULL DEFAULT NOW()
    );

ALTER TABLE public.event_date_rules ENABLE ROW LEVEL SECURITY;

-- Policies for Event Date Rules
CREATE POLICY "Date Rules are viewable for events that can be seen" ON event_date_rules FOR
SELECT
    TO authenticated,
    anon USING (
        EXISTS (
            SELECT
                1
            FROM
                events
            WHERE
                events.id = event_date_rules.event_id
        )
    );

-- WORKING ON Event DATE RULES RLS. 
CREATE POLICY "Users can create date rules on events they own" ON event_date_rules FOR INSERT TO authenticated
WITH
    CHECK (
        EXISTS (
            SELECT
                1
            FROM
                events
            WHERE
                (
                    SELECT
                        auth.uid ()
                ) = events.user_id
                AND events.id = event_date_rules.event_id
        )
    );

CREATE POLICY "Creators can update their date rules" ON event_date_rules FOR
UPDATE TO authenticated USING (
    EXISTS (
        SELECT
            1
        FROM
            events
        WHERE
            (
                SELECT
                    auth.uid ()
            ) = events.user_id
            AND events.id = event_date_rules.event_id
    )
)
WITH
    CHECK (
        EXISTS (
            SELECT
                1
            FROM
                events
            WHERE
                (
                    SELECT
                        auth.uid ()
                ) = events.user_id
                AND events.id = event_date_rules.event_id
        )
    );

CREATE POLICY "Users can delete their date rules" ON event_date_rules FOR DELETE TO authenticated USING (
    EXISTS (
        SELECT
            1
        FROM
            events
        WHERE
            (
                SELECT
                    auth.uid ()
            ) = events.user_id
            AND events.id = event_date_rules.event_id
    )
);