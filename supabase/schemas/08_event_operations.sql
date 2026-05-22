CREATE TABLE event_date_rule_operations(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    event_date_rule_id uuid NOT NULL,
    FOREIGN KEY (event_date_rule_id) REFERENCES event_date_rules(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    config jsonb NOT NULL,
    sort_order integer NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.event_date_rule_operations ENABLE ROW LEVEL SECURITY;

-- Policies for Tradition Prep Steps
CREATE POLICY "Event date rule operations are viewable for events the user can
    see." ON event_date_rule_operations
    FOR SELECT TO authenticated, anon
    USING (EXISTS (
        SELECT
            1
        FROM
            event_date_rules
        WHERE
            event_date_rules.id = event_date_rule_operations.event_date_rule_id));

CREATE POLICY "Users can create event date rule operations on events they own"
    ON event_date_rule_operations
    FOR INSERT TO authenticated
    WITH CHECK (EXISTS (
        SELECT
            1
        FROM
            event_date_rules
            JOIN events ON events.id = event_date_rules.event_id
        WHERE
            event_date_rules.id = event_date_rule_operations.event_date_rule_id
            AND (
                SELECT
                    auth.uid()) = events.user_id));

CREATE POLICY "Users can update event date rule operations on events they own"
    ON event_date_rule_operations
    FOR UPDATE TO authenticated
    USING (EXISTS (
        SELECT
            1
        FROM
            event_date_rules
            JOIN events ON events.id = event_date_rules.event_id
        WHERE
            event_date_rules.id = event_date_rule_operations.event_date_rule_id
            AND (
                SELECT
                    auth.uid()) = events.user_id))
    WITH CHECK (EXISTS (
        SELECT
            1
        FROM
            event_date_rules
            JOIN events ON events.id = event_date_rules.event_id
        WHERE
            event_date_rules.id = event_date_rule_operations.event_date_rule_id
            AND (
                SELECT
                    auth.uid()) = events.user_id));

CREATE POLICY "Users can delete event date rule operations on events they own"
    ON event_date_rule_operations
    FOR DELETE TO authenticated
    USING (EXISTS (
        SELECT
            1
        FROM
            event_date_rules
            JOIN events ON events.id = event_date_rules.event_id
        WHERE
            event_date_rules.id = event_date_rule_operations.event_date_rule_id
            AND (
                SELECT
                    auth.uid()) = events.user_id));
