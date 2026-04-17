CREATE TABLE
    tradition_prep_steps (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        parent_step_id UUID,
        tradition_id UUID NOT NULL,
        FOREIGN KEY (tradition_id) REFERENCES traditions (id) ON DELETE CASCADE,
        user_id UUID REFERENCES auth.users (id) ON DELETE SET NULL DEFAULT auth.uid (),
        -- title text not null,
        description TEXT NOT NULL,
        -- offset_days integer not null,
        sort_order INTEGER NOT NULL,
        step_type TEXT NOT NULL CHECK (step_type IN ('default', 'custom')) DEFAULT 'custom',
        created_at timestamptz NOT NULL DEFAULT NOW(),
        FOREIGN KEY (parent_step_id) REFERENCES tradition_prep_steps (id) ON DELETE SET NULL
    );

ALTER TABLE public.tradition_prep_steps ENABLE ROW LEVEL SECURITY;

-- Policies for Tradition Prep Steps
CREATE POLICY "You can view your steps and default steps." ON tradition_prep_steps FOR
SELECT
    TO authenticated,
    anon USING (
        (
            EXISTS (
                SELECT
                    1
                FROM
                    traditions
                WHERE
                    traditions.id = tradition_prep_steps.tradition_id
            )
            AND tradition_prep_steps.step_type = 'default'
        )
        OR (
            EXISTS (
                SELECT
                    1
                FROM
                    traditions
                WHERE
                    traditions.id = tradition_prep_steps.tradition_id
            )
            AND tradition_prep_steps.user_id = (
                SELECT
                    auth.uid ()
            )
        )
    );

CREATE POLICY "Users can create steps on favorited and owned traditions" ON tradition_prep_steps FOR INSERT TO authenticated
WITH
    CHECK (
        (
            (
                SELECT
                    auth.uid ()
            ) = tradition_prep_steps.user_id
            AND EXISTS (
                SELECT
                    1
                FROM
                    traditions
                WHERE
                    traditions.id = tradition_prep_steps.tradition_id
                    AND traditions.user_id = (
                        SELECT
                            auth.uid ()
                    )
            )
        )
        OR (
            (
                SELECT
                    auth.uid ()
            ) = tradition_prep_steps.user_id
            AND EXISTS (
                SELECT
                    1
                FROM
                    user_traditions ut
                WHERE
                    ut.tradition_id = tradition_prep_steps.tradition_id
            )
            AND tradition_prep_steps.step_type = 'custom'
        )
    );

CREATE POLICY "Creators can update their prep steps" ON tradition_prep_steps FOR
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

CREATE POLICY "Users can delete their prep steps" ON tradition_prep_steps FOR DELETE TO authenticated USING (
    (
        SELECT
            auth.uid ()
    ) = user_id
);