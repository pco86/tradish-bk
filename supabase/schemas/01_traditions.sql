CREATE TABLE
    traditions (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
        user_id UUID REFERENCES auth.users (id) ON DELETE SET NULL DEFAULT auth.uid (),
        title TEXT NOT NULL,
        short_description TEXT,
        long_description TEXT,
        notes TEXT,
        visibility TEXT NOT NULL CHECK (visibility IN ('system', 'public', 'private')) DEFAULT 'private',
        created_at timestamptz NOT NULL DEFAULT NOW(),
        updated_at timestamptz NOT NULL DEFAULT NOW(),
        deleted_at timestamptz,
        parent_tradition_id UUID,
        FOREIGN KEY (parent_tradition_id) REFERENCES traditions (id) ON DELETE SET NULL
    );

ALTER TABLE traditions
ADD CONSTRAINT traditions_visibility_creator_check CHECK (
    (
        visibility = 'system'
        AND user_id IS NULL
    )
    OR (
        visibility IN ('public', 'private')
        AND user_id IS NOT NULL
    )
);

-- Enable Row Level Security
ALTER TABLE public.traditions ENABLE ROW LEVEL SECURITY;

-- Policies for Traditions
CREATE POLICY "Tradition selection rules" ON traditions FOR
SELECT
    TO authenticated,
    anon USING (
        visibility IN ('system', 'public')
        OR (
            (
                SELECT
                    auth.uid ()
            ) = user_id
        )
    );

CREATE POLICY "Users can insert public and private traditions" ON traditions FOR INSERT
WITH
    CHECK (
        visibility IN ('public', 'private')
        AND (
            (
                SELECT
                    auth.uid ()
            ) = user_id
        )
    );

CREATE POLICY "Admin can insert any traditions" ON traditions FOR INSERT TO service_role
WITH
    CHECK (TRUE);

CREATE POLICY "Creators can update their traditions" ON traditions FOR
UPDATE TO authenticated USING (
    (
        SELECT
            auth.uid ()
    ) = user_id
)
WITH
    CHECK (
        visibility IN ('public', 'private')
        AND (
            SELECT
                auth.uid ()
        ) = user_id
    );

CREATE POLICY "Admin can update any traditions" ON traditions FOR
UPDATE TO service_role USING (TRUE)
WITH
    CHECK (TRUE);

CREATE POLICY "Admin can delete any traditions" ON traditions FOR DELETE TO service_role USING (TRUE);