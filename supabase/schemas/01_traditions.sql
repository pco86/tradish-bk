CREATE TABLE traditions(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL DEFAULT auth.uid(),
    title text NOT NULL,
    short_description text,
    long_description text,
    notes text,
    visibility text NOT NULL CHECK (visibility IN ('system',
	'public', 'private')) DEFAULT 'private',
    created_at timestamptz NOT NULL DEFAULT NOW(),
    updated_at timestamptz NOT NULL DEFAULT NOW(),
    deleted_at timestamptz,
    event_id uuid,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE SET NULL,
    operations jsonb NOT NULL,
    is_default boolean NOT NULL DEFAULT FALSE
);

ALTER TABLE traditions
    ADD CONSTRAINT traditions_visibility_creator_check CHECK ((visibility =
	'system' AND user_id IS NULL) OR (visibility IN ('public',
	'private') AND user_id IS NOT NULL));

-- TODO: ADD CONTRAINT BELOW WHICH CONFLICTS WITH SNAPLET.
-- CREATE UNIQUE INDEX one_default_tradition_per_event ON traditions(event_id)
-- WHERE
--     is_default = TRUE;
ALTER TABLE traditions
    ADD CONSTRAINT default_tradition_operations_zero CHECK (NOT is_default OR
	operations = NULL);

-- Enable Row Level Security
ALTER TABLE public.traditions ENABLE ROW LEVEL SECURITY;

-- Policies for Traditions
CREATE POLICY "Tradition selection rules" ON traditions
    FOR SELECT TO authenticated, anon
    USING (visibility IN ('system', 'public')
        OR ((
            SELECT
                auth.uid()) = user_id));

CREATE POLICY "Users can insert public and private traditions" ON traditions
    FOR INSERT
    WITH CHECK (visibility IN ('public', 'private')
    AND ((
        SELECT
            auth.uid()) = user_id));

CREATE POLICY "Admin can insert any traditions" ON traditions
    FOR INSERT TO service_role
    WITH CHECK (TRUE);

CREATE POLICY "Creators can update their traditions" ON traditions
    FOR UPDATE TO authenticated
    USING ((
        SELECT
            auth.uid()) = user_id)
    WITH CHECK (visibility IN ('public', 'private')
    AND (
        SELECT
            auth.uid()) = user_id);

CREATE POLICY "Admin can update any traditions" ON traditions
    FOR UPDATE TO service_role
    USING (TRUE)
    WITH CHECK (TRUE);

CREATE POLICY "Admin can delete any traditions" ON traditions
    FOR DELETE TO service_role
    USING (TRUE);
