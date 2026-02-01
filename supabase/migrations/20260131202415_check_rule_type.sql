


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


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";





SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."tradition_date_rules" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "tradition_id" "uuid" NOT NULL,
    "calendar_type" "text",
    "relative_offset" integer,
    "month" integer,
    "day" integer,
    "weekday" integer,
    "week_of_month" integer,
    "interval" integer,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "relative_tradition_id" "uuid",
    CONSTRAINT "tradition_date_rules_calendar_type_check" CHECK (("calendar_type" = ANY (ARRAY['gregorian'::"text", 'lunar'::"text", 'hebrew'::"text", 'islamic'::"text", 'chinese'::"text"])))
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



ALTER TABLE ONLY "public"."tradition_occurrences"
    ADD CONSTRAINT "tradition_occurrences_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."traditions"
    ADD CONSTRAINT "traditions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tradition_date_rules"
    ADD CONSTRAINT "tradition_date_rules_relative_tradition_id_fkey" FOREIGN KEY ("relative_tradition_id") REFERENCES "public"."traditions"("id");



ALTER TABLE ONLY "public"."tradition_date_rules"
    ADD CONSTRAINT "tradition_date_rules_tradition_id_fkey" FOREIGN KEY ("tradition_id") REFERENCES "public"."traditions"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tradition_occurrences"
    ADD CONSTRAINT "tradition_occurrences_tradition_id_fkey" FOREIGN KEY ("tradition_id") REFERENCES "public"."traditions"("id") ON DELETE CASCADE;



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

