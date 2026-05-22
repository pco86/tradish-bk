CREATE TABLE tradition_date_rule_operations(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tradition_id uuid NOT NULL,
    FOREIGN KEY (tradition_id) REFERENCES traditions(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    config jsonb NOT NULL,
    sort_order integer NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.tradition_date_rule_operations ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Tradition date rule operations are viewable for traditions the user can
    see." ON tradition_date_rule_operations
    FOR SELECT TO authenticated, anon
    USING (EXISTS (
        SELECT
            1
        FROM
            traditions
        WHERE
            traditions.id = tradition_date_rule_operations.tradition_id));

CREATE POLICY "Users can create tradition date rule operations on traditions they
    own" ON tradition_date_rule_operations
    FOR INSERT TO authenticated
    WITH CHECK (EXISTS (
        SELECT
            1
        FROM
            traditions
        WHERE
            traditions.id = tradition_date_rule_operations.tradition_id
            AND (
                SELECT
                    auth.uid()) = traditions.user_id));

CREATE POLICY "Users can update tradition date rule operations on traditions
    they own" ON tradition_date_rule_operations
    FOR UPDATE TO authenticated
    USING (EXISTS (
        SELECT
            1
        FROM
            traditions
        WHERE
            traditions.id = tradition_date_rule_operations.tradition_id
            AND (
                SELECT
                    auth.uid()) = traditions.user_id))
    WITH CHECK (EXISTS (
        SELECT
            1
        FROM
            traditions
        WHERE
            traditions.id = tradition_date_rule_operations.tradition_id
            AND (
                SELECT
                    auth.uid()) = traditions.user_id));

CREATE POLICY "Users can delete tradition date rule operations on traditions they own" ON tradition_date_rule_operations
    FOR DELETE TO authenticated
    USING (EXISTS (
        SELECT
            1
        FROM
            traditions
        WHERE
            traditions.id = tradition_date_rule_operations.tradition_id
            AND (
                SELECT
                    auth.uid()) = traditions.user_id));

