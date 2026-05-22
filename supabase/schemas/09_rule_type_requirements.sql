CREATE TABLE rule_type_requirements(
    rule_type text PRIMARY KEY,
    required_fields text[]
);

ALTER TABLE public.rule_type_requirements ENABLE ROW LEVEL SECURITY;
