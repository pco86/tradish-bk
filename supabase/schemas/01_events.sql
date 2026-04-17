CREATE TABLE
    events (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        user_id UUID REFERENCES auth.users (id) ON DELETE SET NULL DEFAULT auth.uid (),
        title TEXT NOT NULL,
        short_description TEXT,
        long_description TEXT,
        visibility TEXT NOT NULL CHECK (visibility IN ('system', 'private')) DEFAULT 'private',
        created_at timestamptz NOT NULL DEFAULT NOW(),
        updated_at timestamptz NOT NULL DEFAULT NOW(),
        deleted_at timestamptz
    );

ALTER TABLE events
ADD CONSTRAINT event_visibility_creator_check CHECK (
    (
        visibility = 'system'
        AND user_id IS NULL
    )
    OR (
        visibility IN ('private')
        AND user_id IS NOT NULL
    )
);

-- Enable Row Level Security
ALTER TABLE public.events ENABLE ROW LEVEL SECURITY;

-- Policies for events
CREATE POLICY "Event selection rules" ON events FOR
SELECT
    TO authenticated,
    anon USING (
        visibility = 'system'
        OR (
            (
                SELECT
                    auth.uid ()
            ) = user_id
        )
    );

CREATE POLICY "Users can insert public and private events" ON events FOR INSERT
WITH
    CHECK (
        visibility = 'private'
        AND (
            (
                SELECT
                    auth.uid ()
            ) = user_id
        )
    );

CREATE POLICY "Admin can insert any event" ON events FOR INSERT TO service_role
WITH
    CHECK (TRUE);

CREATE POLICY "Creators can update their events" ON events FOR
UPDATE TO authenticated USING (
    (
        SELECT
            auth.uid ()
    ) = user_id
)
WITH
    CHECK (
        visibility IN ('private')
        AND (
            SELECT
                auth.uid ()
        ) = user_id
    );

CREATE POLICY "Admin can update any event" ON events FOR
UPDATE TO service_role USING (TRUE)
WITH
    CHECK (TRUE);

CREATE POLICY "Admin can delete any events" ON events FOR DELETE TO service_role USING (TRUE);

CREATE POLICY "Users can delete their events" ON events FOR DELETE TO authenticated USING (
    (
        SELECT
            auth.uid ()
    ) = user_id
);