CREATE TABLE tradition_date_rules(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    tradition_id uuid NOT NULL UNIQUE,
    FOREIGN KEY (tradition_id) REFERENCES traditions(id) ON DELETE CASCADE,
    rule_type text CHECK (rule_type IN ('fixed', 'relative',
	'computed', 'weekly', 'relative-event')),
    ALGORITHM text CHECK (ALGORITHM IN ('easter-western')),
    frequency text CHECK (frequency IN ('weekly', 'monthly', 'yearly')),
    operations text[],
    calendar_type text CHECK (calendar_type IN ('gregorian',
	'lunar', 'hebrew', 'islamic', 'chinese'))
	DEFAULT 'gregorian',
    relative_tradition_id uuid,
    FOREIGN KEY (relative_tradition_id) REFERENCES traditions(id),
    relative_event_id uuid,
    FOREIGN KEY (relative_event_id) REFERENCES events(id),
    month integer,
    day integer,
    weekday integer,
    week_of_month integer,
    INTERVAL integer,
    created_at timestamptz NOT NULL DEFAULT NOW(),
    updated_at timestamptz NOT NULL DEFAULT NOW()
);

ALTER TABLE public.tradition_date_rules ENABLE ROW LEVEL SECURITY;

-- Policies for Tradition Date Rules
CREATE POLICY "Date Rules are viewable for traditions that can be seen" ON
    tradition_date_rules
    FOR SELECT TO authenticated, anon
    USING (EXISTS (
        SELECT
            1
        FROM
            traditions
        WHERE
            traditions.id = tradition_date_rules.tradition_id));

-- WORKING ON TRADITION DATE RULES RLS.
CREATE POLICY "Users can create date rules on traditions they own" ON
    tradition_date_rules
    FOR INSERT TO authenticated
    WITH CHECK (EXISTS (
        SELECT
            1
        FROM
            traditions
        WHERE (
            SELECT
                auth.uid()) = traditions.user_id
                AND traditions.id = tradition_date_rules.tradition_id));

CREATE POLICY "Creators can update their completion date rules" ON tradition_date_rules
    FOR UPDATE TO authenticated
    USING (EXISTS (
        SELECT
            1
        FROM
            traditions
        WHERE (
            SELECT
                auth.uid()) = traditions.user_id
                AND traditions.id = tradition_date_rules.tradition_id))
    WITH CHECK (EXISTS (
        SELECT
            1
        FROM
            traditions
        WHERE (
            SELECT
                auth.uid()) = traditions.user_id
                AND traditions.id = tradition_date_rules.tradition_id));

CREATE POLICY "Users can delete their date rules" ON tradition_date_rules
    FOR DELETE TO authenticated
    USING (EXISTS (
        SELECT
            1
        FROM
            traditions
        WHERE (
            SELECT
                auth.uid()) = traditions.user_id
                AND traditions.id = tradition_date_rules.tradition_id));
