CREATE TABLE
    user_traditions (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        user_id UUID NOT NULL REFERENCES auth.users (id) ON DELETE CASCADE DEFAULT auth.uid (),
        tradition_id UUID,
        FOREIGN KEY (tradition_id) REFERENCES traditions (id) ON DELETE CASCADE,
        reminders_enabled BOOLEAN NOT NULL DEFAULT TRUE,
        notification_time TIME,
        created_at timestamptz DEFAULT NOW(),
        UNIQUE (user_id, tradition_id)
    );

CREATE INDEX ON user_traditions (tradition_id);

ALTER TABLE public.user_traditions ENABLE ROW LEVEL SECURITY;

-- Polcies for User Traditions
CREATE POLICY "User traditions are viewable by owner" ON user_traditions FOR
SELECT
    USING (
        (
            SELECT
                auth.uid ()
        ) = user_id
    );

CREATE POLICY "Users can create user traditions" ON user_traditions FOR INSERT TO authenticated
WITH
    CHECK (
        (
            SELECT
                auth.uid ()
        ) = user_id
    );

CREATE POLICY "Users can update user traditions" ON user_traditions FOR
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

CREATE POLICY "Users can delete user traditions" ON user_traditions FOR DELETE TO authenticated USING (
    (
        SELECT
            auth.uid ()
    ) = user_id
);