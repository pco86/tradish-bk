CREATE TABLE
    user_steps_complete (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        occurrence_id UUID NOT NULL,
        FOREIGN KEY (occurrence_id) REFERENCES tradition_occurrences (id) ON DELETE CASCADE,
        step_id UUID NOT NULL,
        FOREIGN KEY (step_id) REFERENCES tradition_prep_steps (id) ON DELETE CASCADE,
        is_completed BOOLEAN NOT NULL DEFAULT TRUE,
        created_at timestamptz NOT NULL DEFAULT NOW(),
        updated_at timestamptz NOT NULL DEFAULT NOW(),
        user_id UUID REFERENCES auth.users (id) ON DELETE SET NULL DEFAULT auth.uid (),
        UNIQUE (occurrence_id, step_id)
    );

ALTER TABLE public.user_steps_complete ENABLE ROW LEVEL SECURITY;

-- Polcies for User Steps Complete
CREATE POLICY "User tradition prep completion steps are viewable by owner" ON user_steps_complete FOR
SELECT
    TO authenticated USING (
        (
            SELECT
                auth.uid ()
        ) = user_id
    );

CREATE POLICY "Users can complete steps they can view." ON user_steps_complete FOR INSERT TO authenticated
WITH
    CHECK (
        (
            EXISTS (
                SELECT
                    1
                FROM
                    tradition_prep_steps
                WHERE
                    user_steps_complete.step_id = tradition_prep_steps.id
            )
        )
    );

CREATE POLICY "Creators can update their completion steps" ON user_steps_complete FOR
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

CREATE POLICY "Users can delete their completion steps" ON user_steps_complete FOR DELETE TO authenticated USING (
    (
        SELECT
            auth.uid ()
    ) = user_id
);