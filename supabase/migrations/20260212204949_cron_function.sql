SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";
CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";
CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";
CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

COMMENT ON SCHEMA "public" IS 'standard public schema';


CREATE OR REPLACE FUNCTION "public"."excute_add_occurrences_new_tradition"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    webhook_url TEXT;
    api_key TEXT;
    -- Define other variables if needed
BEGIN
    -- Retrieve the secret values from the vault.decrypted_secrets view
    SELECT decrypted_secret INTO webhook_url FROM vault.decrypted_secrets WHERE name = 'add_occurrences_new_tradition';
    SELECT decrypted_secret INTO api_key FROM vault.decrypted_secrets WHERE name = 'webhook_secret';

    IF webhook_url is null then
        return null;
    end if;

    if api_key is null then
        return null;
    end if;

    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    PERFORM net.http_post(
        url := webhook_url,
        body := to_jsonb(NEW),
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'X-Webhook-Secret', 'Bearer ' || api_key
        )
    );

    RETURN NEW;
END;
$$;

ALTER FUNCTION "public"."excute_add_occurrences_new_tradition"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."schedule_occurrence_generation"() RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    webhook_url TEXT;
    api_key TEXT;
    -- Define other variables if needed
BEGIN
    -- Retrieve the secret values from the vault.decrypted_secrets view
    SELECT decrypted_secret INTO webhook_url FROM vault.decrypted_secrets WHERE name = 'schedule_occurrence_generation';
    SELECT decrypted_secret INTO api_key FROM vault.decrypted_secrets WHERE name = 'webhook_secret';

    IF webhook_url is null then
        return;
    end if;

    if api_key is null then
        return;
    end if;

    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    PERFORM net.http_post(
        url := webhook_url,
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'X-Webhook-Secret', 'Bearer ' || api_key
        )
    );
END;
$$;

ALTER FUNCTION "public"."schedule_occurrence_generation"() OWNER TO "postgres";

SET default_tablespace = '';
SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."tradition_date_rules" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tradition_id" "uuid" NOT NULL,
    "calendar_type" "text",
    "month" integer,
    "day" integer,
    "weekday" integer,
    "week_of_month" integer,
    "interval" integer,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "relative_tradition_id" "uuid",
    "operations" "text"[],
    "rule_type" "text",
    "algorithm" "text",
    "frequency" "text",
    CONSTRAINT "tradition_date_rules_algorithm_check" CHECK (("algorithm" = 'easter-western'::"text")),
    CONSTRAINT "tradition_date_rules_calendar_type_check" CHECK (("calendar_type" = ANY (ARRAY['gregorian'::"text", 'lunar'::"text", 'hebrew'::"text", 'islamic'::"text", 'chinese'::"text"]))),
    CONSTRAINT "tradition_date_rules_frequency_check" CHECK (("frequency" = ANY (ARRAY['weekly'::"text", 'monthly'::"text", 'yearly'::"text"]))),
    CONSTRAINT "tradition_date_rules_rule_type_check" CHECK (("rule_type" = ANY (ARRAY['fixed'::"text", 'relative'::"text", 'computed'::"text", 'weekly'::"text"])))
);
ALTER TABLE "public"."tradition_date_rules" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."tradition_occurrences" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tradition_id" "uuid" NOT NULL,
    "occurs_on" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);
ALTER TABLE "public"."tradition_occurrences" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."traditions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text",
    "short_description" "text",
    "long_description" "text",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL
);
ALTER TABLE "public"."traditions" OWNER TO "postgres";


ALTER TABLE ONLY "public"."tradition_date_rules"
    ADD CONSTRAINT "tradition_date_rules_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."tradition_date_rules"
    ADD CONSTRAINT "tradition_date_rules_tradition_id_key" UNIQUE ("tradition_id");
ALTER TABLE ONLY "public"."tradition_occurrences"
    ADD CONSTRAINT "tradition_occurrences_pkey" PRIMARY KEY ("id");
ALTER TABLE ONLY "public"."tradition_occurrences"
    ADD CONSTRAINT "tradition_occurrences_tradition_id_occurs_on_key" UNIQUE ("tradition_id", "occurs_on");
ALTER TABLE ONLY "public"."traditions"
    ADD CONSTRAINT "traditions_pkey" PRIMARY KEY ("id");

CREATE OR REPLACE TRIGGER "add_occurrences_new_tradition" AFTER INSERT ON "public"."tradition_date_rules" FOR EACH ROW EXECUTE FUNCTION "public"."excute_add_occurrences_new_tradition"();

ALTER TABLE ONLY "public"."tradition_date_rules"
    ADD CONSTRAINT "tradition_date_rules_relative_tradition_id_fkey" FOREIGN KEY ("relative_tradition_id") REFERENCES "public"."traditions"("id");
ALTER TABLE ONLY "public"."tradition_date_rules"
    ADD CONSTRAINT "tradition_date_rules_tradition_id_fkey" FOREIGN KEY ("tradition_id") REFERENCES "public"."traditions"("id") ON DELETE CASCADE;
ALTER TABLE ONLY "public"."tradition_occurrences"
    ADD CONSTRAINT "tradition_occurrences_tradition_id_fkey" FOREIGN KEY ("tradition_id") REFERENCES "public"."traditions"("id") ON DELETE CASCADE;

CREATE POLICY "Date Rules are viewable by everyone" ON "public"."tradition_date_rules" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Occurrences are viewable by everyone" ON "public"."tradition_occurrences" FOR SELECT TO "authenticated", "anon" USING (true);
CREATE POLICY "Traditions are viewable by everyone" ON "public"."traditions" FOR SELECT TO "authenticated", "anon" USING (true);

ALTER TABLE "public"."tradition_date_rules" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."tradition_occurrences" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."traditions" ENABLE ROW LEVEL SECURITY;

ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

select cron.schedule('schedule-materialization', '0 0 * * *', 'SELECT public.schedule_occurrence_generation()');

GRANT ALL ON FUNCTION "public"."excute_add_occurrences_new_tradition"() TO "anon";
GRANT ALL ON FUNCTION "public"."excute_add_occurrences_new_tradition"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."excute_add_occurrences_new_tradition"() TO "service_role";

GRANT ALL ON FUNCTION "public"."schedule_occurrence_generation"() TO "anon";
GRANT ALL ON FUNCTION "public"."schedule_occurrence_generation"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."schedule_occurrence_generation"() TO "service_role";

GRANT ALL ON TABLE "public"."tradition_date_rules" TO "anon";
GRANT ALL ON TABLE "public"."tradition_date_rules" TO "authenticated";
GRANT ALL ON TABLE "public"."tradition_date_rules" TO "service_role";

GRANT ALL ON TABLE "public"."tradition_occurrences" TO "anon";
GRANT ALL ON TABLE "public"."tradition_occurrences" TO "authenticated";
GRANT ALL ON TABLE "public"."tradition_occurrences" TO "service_role";

GRANT ALL ON TABLE "public"."traditions" TO "anon";
GRANT ALL ON TABLE "public"."traditions" TO "authenticated";
GRANT ALL ON TABLE "public"."traditions" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";



--
-- Dumped schema changes for auth and storage
--

