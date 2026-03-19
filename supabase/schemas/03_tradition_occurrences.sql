CREATE TABLE
    tradition_occurrences (
        id uuid PRIMARY KEY DEFAULT gen_random_uuid (),
        tradition_id uuid NOT NULL,
        FOREIGN KEY (tradition_id) REFERENCES traditions (id) ON DELETE CASCADE,
        occurs_on text,
        UNIQUE (tradition_id, occurs_on),
        created_at timestamptz NOT NULL DEFAULT NOW(),
        updated_at timestamptz NOT NULL DEFAULT NOW()
    );

ALTER TABLE public.tradition_occurrences enable ROW LEVEL SECURITY;

-- Policies for Tradition Occurrences
CREATE policy "Occurrences are viewable based on tradition permissions" ON tradition_occurrences FOR
SELECT
    TO authenticated,
    anon USING (
        EXISTS (
            SELECT
                1
            FROM
                traditions
            WHERE
                traditions.id = tradition_occurrences.tradition_id
        )
    );