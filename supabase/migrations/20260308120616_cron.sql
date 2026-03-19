CREATE EXTENSION IF NOT EXISTS "pg_cron"
WITH
    SCHEMA "pg_catalog";

SELECT
    cron.schedule (
        'schedule-materialization',
        '0 0 * * *',
        'SELECT public.schedule_occurrence_generation()'
    );