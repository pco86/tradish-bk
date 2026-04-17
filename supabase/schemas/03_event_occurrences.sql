CREATE TABLE
    event_occurrences (
        id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
        event_id uuid NOT NULL,
        FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE,
        occurs_on text,
        UNIQUE (event_id, occurs_on),
        created_at timestamptz NOT NULL DEFAULT NOW(),
        updated_at timestamptz NOT NULL DEFAULT NOW()
    );

ALTER TABLE public.event_occurrences enable ROW LEVEL SECURITY;

-- Policies for Event Occurrences
CREATE policy "Occurrences are viewable based on event permissions" ON event_occurrences FOR
SELECT
    TO authenticated,
    anon USING (
        EXISTS (
            SELECT
                1
            FROM
                events
            WHERE
                events.id = event_occurrences.event_id
        )
    );