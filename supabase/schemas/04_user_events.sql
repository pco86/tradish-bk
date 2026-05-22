CREATE TABLE
    user_events (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        user_id UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE DEFAULT auth.uid (),
        event_id UUID,
        FOREIGN KEY (event_id) REFERENCES events (id) ON DELETE CASCADE,
        reminders_enabled BOOLEAN NOT NULL DEFAULT TRUE,
        notification_time TIME,
        created_at timestamptz DEFAULT NOW(),
        UNIQUE (user_id, event_id)
    );

CREATE INDEX ON user_events (event_id);

ALTER TABLE public.user_events ENABLE ROW LEVEL SECURITY;

-- Polcies for User Events
CREATE POLICY "User events are viewable by owner" ON user_events FOR
SELECT
    USING (
        (
            SELECT
                auth.uid ()
        ) = user_id
    );

CREATE POLICY "Users can create user events" ON user_events FOR INSERT TO authenticated
WITH
    CHECK (
        (
            SELECT
                auth.uid ()
        ) = user_id
    );

CREATE POLICY "Users can update user events" ON user_events FOR
UPDATE TO authenticated USING (
    (
        SELECT
            auth.uid ()
    ) = user_id
)
WITH
    CHECK (
        (
            SELECT
                auth.uid ()
        ) = user_id
    );

CREATE POLICY "Users can delete user events" ON user_events FOR DELETE TO authenticated USING (
    (
        SELECT
            auth.uid ()
    ) = user_id
);