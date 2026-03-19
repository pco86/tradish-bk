SET
    statement_timeout = 0;

SET
    lock_timeout = 0;

SET
    idle_in_transaction_session_timeout = 0;

SET
    client_encoding = 'UTF8';

SET
    standard_conforming_strings = ON;

SELECT
    pg_catalog.set_config ('search_path', '', FALSE);

SET
    check_function_bodies = FALSE;

SET
    xmloption = CONTENT;

SET
    client_min_messages = warning;

SET
    row_security = OFF;

CREATE EXTENSION IF NOT EXISTS "pg_cron"
WITH
    SCHEMA "pg_catalog";

CREATE EXTENSION IF NOT EXISTS "pg_net"
WITH
    SCHEMA "extensions";

COMMENT ON SCHEMA "public" IS 'standard public schema';

CREATE EXTENSION IF NOT EXISTS "pg_graphql"
WITH
    SCHEMA "graphql";

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements"
WITH
    SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgcrypto"
WITH
    SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "supabase_vault"
WITH
    SCHEMA "vault";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp"
WITH
    SCHEMA "extensions";

CREATE
OR REPLACE FUNCTION "public"."copy_steps_on_favorite" () RETURNS "trigger" LANGUAGE "plpgsql" AS $$
begin
  insert into user_tradition_prep_steps(
    user_tradition_id, 
    tradition_prep_step_id, 
    sort_order
  )
  select new.id, id, sort_order from tradition_prep_steps
  where tradition_id = new.tradition_id;
  return new;
end;
$$;

ALTER FUNCTION "public"."copy_steps_on_favorite" () OWNER TO "postgres";

CREATE
OR REPLACE FUNCTION "public"."excute_add_occurrences_new_tradition" () RETURNS "trigger" LANGUAGE "plpgsql" SECURITY DEFINER
SET
    "search_path" TO 'public' AS $$
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

ALTER FUNCTION "public"."excute_add_occurrences_new_tradition" () OWNER TO "postgres";

CREATE
OR REPLACE FUNCTION "public"."schedule_occurrence_generation" () RETURNS "void" LANGUAGE "plpgsql" SECURITY DEFINER
SET
    "search_path" TO 'public' AS $$
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

ALTER FUNCTION "public"."schedule_occurrence_generation" () OWNER TO "postgres";

CREATE
OR REPLACE FUNCTION "public"."set_updated_at" () RETURNS "trigger" LANGUAGE "plpgsql" AS $$
begin
  new.updated_at = now();
  new.version = old.version + 1;
  return new;
end;
$$;

ALTER FUNCTION "public"."set_updated_at" () OWNER TO "postgres";

SET
    default_tablespace = '';

SET
    default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS
    "public"."tradition_date_rules" (
        "id" "uuid" DEFAULT "gen_random_uuid" () NOT NULL,
        "tradition_id" "uuid" NOT NULL,
        "calendar_type" "text",
        "month" INTEGER,
        "day" INTEGER,
        "weekday" INTEGER,
        "week_of_month" INTEGER,
        "interval" INTEGER,
        "created_at" TIMESTAMP WITH TIME ZONE DEFAULT "now" () NOT NULL,
        "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT "now" () NOT NULL,
        "relative_tradition_id" "uuid",
        "operations" "text" [],
        "rule_type" "text",
        "algorithm" "text",
        "frequency" "text",
        CONSTRAINT "tradition_date_rules_algorithm_check" CHECK (("algorithm" = 'easter-western'::"text")),
        CONSTRAINT "tradition_date_rules_calendar_type_check" CHECK (
            (
                "calendar_type" = ANY (
                    ARRAY[
                        'gregorian'::"text",
                        'lunar'::"text",
                        'hebrew'::"text",
                        'islamic'::"text",
                        'chinese'::"text"
                    ]
                )
            )
        ),
        CONSTRAINT "tradition_date_rules_frequency_check" CHECK (
            (
                "frequency" = ANY (
                    ARRAY[
                        'weekly'::"text",
                        'monthly'::"text",
                        'yearly'::"text"
                    ]
                )
            )
        ),
        CONSTRAINT "tradition_date_rules_rule_type_check" CHECK (
            (
                "rule_type" = ANY (
                    ARRAY[
                        'fixed'::"text",
                        'relative'::"text",
                        'computed'::"text",
                        'weekly'::"text"
                    ]
                )
            )
        )
    );

ALTER TABLE "public"."tradition_date_rules" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS
    "public"."tradition_occurrences" (
        "id" "uuid" DEFAULT "gen_random_uuid" () NOT NULL,
        "tradition_id" "uuid" NOT NULL,
        "occurs_on" "text",
        "created_at" TIMESTAMP WITH TIME ZONE DEFAULT "now" () NOT NULL,
        "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT "now" () NOT NULL
    );

ALTER TABLE "public"."tradition_occurrences" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS
    "public"."tradition_prep_steps" (
        "id" "uuid" DEFAULT "gen_random_uuid" () NOT NULL,
        "tradition_id" "uuid" NOT NULL,
        "description" "text" NOT NULL,
        "sort_order" INTEGER NOT NULL,
        "created_at" TIMESTAMP WITH TIME ZONE DEFAULT "now" () NOT NULL
    );

ALTER TABLE "public"."tradition_prep_steps" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS
    "public"."traditions" (
        "id" "uuid" DEFAULT "gen_random_uuid" () NOT NULL,
        "title" "text" NOT NULL,
        "short_description" "text",
        "long_description" "text",
        "created_at" TIMESTAMP WITH TIME ZONE DEFAULT "now" () NOT NULL,
        "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT "now" () NOT NULL,
        "visibility" "text" DEFAULT 'private'::"text" NOT NULL,
        "deleted_at" TIMESTAMP WITH TIME ZONE,
        "user_id" "uuid",
        "version" INTEGER,
        CONSTRAINT "traditions_visibility_check" CHECK (
            (
                "visibility" = ANY (
                    ARRAY[
                        'system'::"text",
                        'public'::"text",
                        'private'::"text"
                    ]
                )
            )
        ),
        CONSTRAINT "traditions_visibility_creator_check" CHECK (
            (
                (
                    ("visibility" = 'system'::"text")
                    AND ("user_id" IS NULL)
                )
                OR (
                    (
                        "visibility" = ANY (ARRAY['public'::"text", 'private'::"text"])
                    )
                    AND ("user_id" IS NOT NULL)
                )
            )
        )
    );

ALTER TABLE "public"."traditions" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS
    "public"."user_steps_complete" (
        "id" "uuid" DEFAULT "gen_random_uuid" () NOT NULL,
        "occurrence_id" "uuid" NOT NULL,
        "user_step_id" "uuid" NOT NULL,
        "is_completed" BOOLEAN DEFAULT FALSE NOT NULL,
        "completed_at" TIMESTAMP WITH TIME ZONE,
        "created_at" TIMESTAMP WITH TIME ZONE DEFAULT "now" () NOT NULL,
        "updated_at" TIMESTAMP WITH TIME ZONE DEFAULT "now" () NOT NULL
    );

ALTER TABLE "public"."user_steps_complete" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS
    "public"."user_tradition_prep_steps" (
        "id" "uuid" DEFAULT "gen_random_uuid" () NOT NULL,
        "user_tradition_id" "uuid" NOT NULL,
        "tradition_prep_step_id" "uuid",
        "custom_description" "text",
        "is_removed" BOOLEAN DEFAULT FALSE NOT NULL,
        "sort_order" INTEGER NOT NULL,
        "created_at" TIMESTAMP WITH TIME ZONE DEFAULT "now" () NOT NULL
    );

ALTER TABLE "public"."user_tradition_prep_steps" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS
    "public"."user_traditions" (
        "user_id" "uuid" DEFAULT "auth"."uid" () NOT NULL,
        "tradition_id" "uuid" NOT NULL,
        "custom_title" "text",
        "notes" "text",
        "reminders_enabled" BOOLEAN DEFAULT TRUE NOT NULL,
        "notification_time" TIME WITHOUT TIME ZONE,
        "created_at" TIMESTAMP WITH TIME ZONE DEFAULT "now" (),
        "id" "uuid" DEFAULT "gen_random_uuid" () NOT NULL,
        "is_favorite" BOOLEAN DEFAULT TRUE NOT NULL
    );

ALTER TABLE "public"."user_traditions" OWNER TO "postgres";

ALTER TABLE ONLY "public"."tradition_date_rules"
ADD CONSTRAINT "tradition_date_rules_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."tradition_date_rules"
ADD CONSTRAINT "tradition_date_rules_tradition_id_key" UNIQUE ("tradition_id");

ALTER TABLE ONLY "public"."tradition_occurrences"
ADD CONSTRAINT "tradition_occurrences_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."tradition_occurrences"
ADD CONSTRAINT "tradition_occurrences_tradition_id_occurs_on_key" UNIQUE ("tradition_id", "occurs_on");

ALTER TABLE ONLY "public"."tradition_prep_steps"
ADD CONSTRAINT "tradition_prep_steps_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."tradition_prep_steps"
ADD CONSTRAINT "tradition_prep_steps_tradition_id_sort_order_key" UNIQUE ("tradition_id", "sort_order");

ALTER TABLE ONLY "public"."traditions"
ADD CONSTRAINT "traditions_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."user_steps_complete"
ADD CONSTRAINT "user_steps_complete_occurrence_id_user_step_id_key" UNIQUE ("occurrence_id", "user_step_id");

ALTER TABLE ONLY "public"."user_steps_complete"
ADD CONSTRAINT "user_steps_complete_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."user_tradition_prep_steps"
ADD CONSTRAINT "user_tradition_prep_steps_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."user_tradition_prep_steps"
ADD CONSTRAINT "user_tradition_prep_steps_user_tradition_id_tradition_prep__key" UNIQUE ("user_tradition_id", "tradition_prep_step_id");

ALTER TABLE ONLY "public"."user_traditions"
ADD CONSTRAINT "user_traditions_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."user_traditions"
ADD CONSTRAINT "user_traditions_user_id_tradition_id_key" UNIQUE ("user_id", "tradition_id");

CREATE INDEX "user_traditions_tradition_id_idx" ON "public"."user_traditions" USING "btree" ("tradition_id");

CREATE
OR REPLACE TRIGGER "add_occurrences_new_tradition"
AFTER INSERT ON "public"."tradition_date_rules" FOR EACH ROW
EXECUTE FUNCTION "public"."excute_add_occurrences_new_tradition" ();

CREATE
OR REPLACE TRIGGER "copy_steps_trigger"
AFTER INSERT ON "public"."user_traditions" FOR EACH ROW
EXECUTE FUNCTION "public"."copy_steps_on_favorite" ();

CREATE
OR REPLACE TRIGGER "traditions_updated" BEFORE
UPDATE ON "public"."traditions" FOR EACH ROW
EXECUTE FUNCTION "public"."set_updated_at" ();

ALTER TABLE ONLY "public"."tradition_date_rules"
ADD CONSTRAINT "tradition_date_rules_relative_tradition_id_fkey" FOREIGN KEY ("relative_tradition_id") REFERENCES "public"."traditions" ("id");

ALTER TABLE ONLY "public"."tradition_date_rules"
ADD CONSTRAINT "tradition_date_rules_tradition_id_fkey" FOREIGN KEY ("tradition_id") REFERENCES "public"."traditions" ("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."tradition_occurrences"
ADD CONSTRAINT "tradition_occurrences_tradition_id_fkey" FOREIGN KEY ("tradition_id") REFERENCES "public"."traditions" ("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."tradition_prep_steps"
ADD CONSTRAINT "tradition_prep_steps_tradition_id_fkey" FOREIGN KEY ("tradition_id") REFERENCES "public"."traditions" ("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."traditions"
ADD CONSTRAINT "traditions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users" ("id") ON DELETE SET NULL;

ALTER TABLE ONLY "public"."user_steps_complete"
ADD CONSTRAINT "user_steps_complete_occurrence_id_fkey" FOREIGN KEY ("occurrence_id") REFERENCES "public"."tradition_occurrences" ("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user_steps_complete"
ADD CONSTRAINT "user_steps_complete_user_step_id_fkey" FOREIGN KEY ("user_step_id") REFERENCES "public"."user_tradition_prep_steps" ("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user_tradition_prep_steps"
ADD CONSTRAINT "user_tradition_prep_steps_tradition_prep_step_id_fkey" FOREIGN KEY ("tradition_prep_step_id") REFERENCES "public"."tradition_prep_steps" ("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user_tradition_prep_steps"
ADD CONSTRAINT "user_tradition_prep_steps_user_tradition_id_fkey" FOREIGN KEY ("user_tradition_id") REFERENCES "public"."user_traditions" ("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user_tradition_prep_steps"
ADD CONSTRAINT "user_tradition_prep_steps_user_tradition_id_fkey1" FOREIGN KEY ("user_tradition_id") REFERENCES "public"."user_traditions" ("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user_traditions"
ADD CONSTRAINT "user_traditions_tradition_id_fkey" FOREIGN KEY ("tradition_id") REFERENCES "public"."traditions" ("id") ON DELETE CASCADE;

ALTER TABLE ONLY "public"."user_traditions"
ADD CONSTRAINT "user_traditions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users" ("id") ON DELETE CASCADE;

CREATE POLICY "Admin can delete any traditions" ON "public"."traditions" FOR DELETE TO "service_role" USING (TRUE);

CREATE POLICY "Admin can insert any traditions" ON "public"."traditions" FOR INSERT TO "service_role"
WITH
    CHECK (TRUE);

CREATE POLICY "Admin can update any traditions" ON "public"."traditions" FOR
UPDATE TO "service_role" USING (TRUE)
WITH
    CHECK (TRUE);

CREATE POLICY "Creators can delete their traditions" ON "public"."traditions" FOR DELETE TO "authenticated" USING (
    (
        (
            SELECT
                "auth"."uid" () AS "uid"
        ) = "user_id"
    )
);

CREATE POLICY "Creators can update their traditions" ON "public"."traditions" FOR
UPDATE TO "authenticated" USING (
    (
        (
            SELECT
                "auth"."uid" () AS "uid"
        ) = "user_id"
    )
)
WITH
    CHECK (
        (
            (
                SELECT
                    "auth"."uid" () AS "uid"
            ) = "user_id"
        )
    );

CREATE POLICY "Date Rules are viewable by everyone" ON "public"."tradition_date_rules" FOR
SELECT
    TO "authenticated",
    "anon" USING (TRUE);

CREATE POLICY "Occurrences are viewable by everyone" ON "public"."tradition_occurrences" FOR
SELECT
    TO "authenticated",
    "anon" USING (TRUE);

CREATE POLICY "Tradition Prep Steps are viewable by everyone" ON "public"."tradition_prep_steps" FOR
SELECT
    TO "authenticated",
    "anon" USING (TRUE);

CREATE POLICY "Tradition selection rules" ON "public"."traditions" FOR
SELECT
    TO "authenticated",
    "anon" USING (
        (
            (
                "visibility" = ANY (ARRAY['system'::"text", 'public'::"text"])
            )
            OR (
                (
                    SELECT
                        "auth"."uid" () AS "uid"
                ) = "user_id"
            )
        )
    );

CREATE POLICY "User tradition prep completion steps are viewable by owner" ON "public"."user_steps_complete" FOR
SELECT
    USING (
        (
            EXISTS (
                SELECT
                    1
                FROM
                    (
                        "public"."user_tradition_prep_steps" "uts"
                        JOIN "public"."user_traditions" "ut" ON (("ut"."id" = "uts"."user_tradition_id"))
                    )
                WHERE
                    (
                        ("uts"."id" = "user_steps_complete"."user_step_id")
                        AND (
                            "ut"."user_id" = (
                                SELECT
                                    "auth"."uid" () AS "uid"
                            )
                        )
                    )
            )
        )
    );

CREATE POLICY "User tradition prep steps are viewable by owner" ON "public"."user_tradition_prep_steps" FOR
SELECT
    USING (
        (
            EXISTS (
                SELECT
                    1
                FROM
                    "public"."user_traditions" "ut"
                WHERE
                    (
                        (
                            "ut"."id" = "user_tradition_prep_steps"."user_tradition_id"
                        )
                        AND (
                            "ut"."user_id" = (
                                SELECT
                                    "auth"."uid" () AS "uid"
                            )
                        )
                    )
            )
        )
    );

CREATE POLICY "User traditions are viewable by owner" ON "public"."user_traditions" FOR
SELECT
    USING (
        (
            (
                SELECT
                    "auth"."uid" () AS "uid"
            ) = "user_id"
        )
    );

CREATE POLICY "Users can create user tradition prep steps" ON "public"."user_tradition_prep_steps" FOR INSERT TO "authenticated"
WITH
    CHECK (
        (
            EXISTS (
                SELECT
                    1
                FROM
                    "public"."user_traditions" "ut"
                WHERE
                    (
                        (
                            "ut"."id" = "user_tradition_prep_steps"."user_tradition_id"
                        )
                        AND (
                            "ut"."user_id" = (
                                SELECT
                                    "auth"."uid" () AS "uid"
                            )
                        )
                    )
            )
        )
    );

CREATE POLICY "Users can create user traditions" ON "public"."user_traditions" FOR INSERT TO "authenticated"
WITH
    CHECK (
        (
            (
                SELECT
                    "auth"."uid" () AS "uid"
            ) = "user_id"
        )
    );

CREATE POLICY "Users can delete user tradition prep steps" ON "public"."user_tradition_prep_steps" FOR DELETE TO "authenticated" USING (
    (
        EXISTS (
            SELECT
                1
            FROM
                "public"."user_traditions" "ut"
            WHERE
                (
                    (
                        "ut"."id" = "user_tradition_prep_steps"."user_tradition_id"
                    )
                    AND (
                        "ut"."user_id" = (
                            SELECT
                                "auth"."uid" () AS "uid"
                        )
                    )
                )
        )
    )
);

CREATE POLICY "Users can delete user traditions" ON "public"."user_traditions" FOR DELETE TO "authenticated" USING (
    (
        (
            SELECT
                "auth"."uid" () AS "uid"
        ) = "user_id"
    )
);

CREATE POLICY "Users can insert public and private traditions" ON "public"."traditions" FOR INSERT
WITH
    CHECK (
        (
            (
                "visibility" = ANY (ARRAY['public'::"text", 'private'::"text"])
            )
            AND (
                (
                    SELECT
                        "auth"."uid" () AS "uid"
                ) = "user_id"
            )
        )
    );

CREATE POLICY "Users can update user tradition prep steps" ON "public"."user_tradition_prep_steps" FOR
UPDATE TO "authenticated" USING (
    (
        EXISTS (
            SELECT
                1
            FROM
                "public"."user_traditions" "ut"
            WHERE
                (
                    (
                        "ut"."id" = "user_tradition_prep_steps"."user_tradition_id"
                    )
                    AND (
                        "ut"."user_id" = (
                            SELECT
                                "auth"."uid" () AS "uid"
                        )
                    )
                )
        )
    )
)
WITH
    CHECK (
        (
            EXISTS (
                SELECT
                    1
                FROM
                    "public"."user_traditions" "ut"
                WHERE
                    (
                        (
                            "ut"."id" = "user_tradition_prep_steps"."user_tradition_id"
                        )
                        AND (
                            "ut"."user_id" = (
                                SELECT
                                    "auth"."uid" () AS "uid"
                            )
                        )
                    )
            )
        )
    );

CREATE POLICY "Users can update user traditions" ON "public"."user_traditions" FOR
UPDATE TO "authenticated" USING (
    (
        (
            SELECT
                "auth"."uid" () AS "uid"
        ) = "user_id"
    )
)
WITH
    CHECK (
        (
            (
                SELECT
                    "auth"."uid" () AS "uid"
            ) = "user_id"
        )
    );

ALTER TABLE "public"."tradition_date_rules" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."tradition_occurrences" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."tradition_prep_steps" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."traditions" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."user_steps_complete" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."user_tradition_prep_steps" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."user_traditions" ENABLE ROW LEVEL SECURITY;

ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";

GRANT USAGE ON SCHEMA "public" TO "postgres";

GRANT USAGE ON SCHEMA "public" TO "anon";

GRANT USAGE ON SCHEMA "public" TO "authenticated";

GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON FUNCTION "public"."copy_steps_on_favorite" () TO "anon";

GRANT ALL ON FUNCTION "public"."copy_steps_on_favorite" () TO "authenticated";

GRANT ALL ON FUNCTION "public"."copy_steps_on_favorite" () TO "service_role";

GRANT ALL ON FUNCTION "public"."excute_add_occurrences_new_tradition" () TO "anon";

GRANT ALL ON FUNCTION "public"."excute_add_occurrences_new_tradition" () TO "authenticated";

GRANT ALL ON FUNCTION "public"."excute_add_occurrences_new_tradition" () TO "service_role";

GRANT ALL ON FUNCTION "public"."schedule_occurrence_generation" () TO "anon";

GRANT ALL ON FUNCTION "public"."schedule_occurrence_generation" () TO "authenticated";

GRANT ALL ON FUNCTION "public"."schedule_occurrence_generation" () TO "service_role";

GRANT ALL ON FUNCTION "public"."set_updated_at" () TO "anon";

GRANT ALL ON FUNCTION "public"."set_updated_at" () TO "authenticated";

GRANT ALL ON FUNCTION "public"."set_updated_at" () TO "service_role";

GRANT ALL ON TABLE "public"."tradition_date_rules" TO "anon";

GRANT ALL ON TABLE "public"."tradition_date_rules" TO "authenticated";

GRANT ALL ON TABLE "public"."tradition_date_rules" TO "service_role";

GRANT ALL ON TABLE "public"."tradition_occurrences" TO "anon";

GRANT ALL ON TABLE "public"."tradition_occurrences" TO "authenticated";

GRANT ALL ON TABLE "public"."tradition_occurrences" TO "service_role";

GRANT ALL ON TABLE "public"."tradition_prep_steps" TO "anon";

GRANT ALL ON TABLE "public"."tradition_prep_steps" TO "authenticated";

GRANT ALL ON TABLE "public"."tradition_prep_steps" TO "service_role";

GRANT ALL ON TABLE "public"."traditions" TO "anon";

GRANT ALL ON TABLE "public"."traditions" TO "authenticated";

GRANT ALL ON TABLE "public"."traditions" TO "service_role";

GRANT ALL ON TABLE "public"."user_steps_complete" TO "anon";

GRANT ALL ON TABLE "public"."user_steps_complete" TO "authenticated";

GRANT ALL ON TABLE "public"."user_steps_complete" TO "service_role";

GRANT ALL ON TABLE "public"."user_tradition_prep_steps" TO "anon";

GRANT ALL ON TABLE "public"."user_tradition_prep_steps" TO "authenticated";

GRANT ALL ON TABLE "public"."user_tradition_prep_steps" TO "service_role";

GRANT ALL ON TABLE "public"."user_traditions" TO "anon";

GRANT ALL ON TABLE "public"."user_traditions" TO "authenticated";

GRANT ALL ON TABLE "public"."user_traditions" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON SEQUENCES TO "postgres";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON SEQUENCES TO "anon";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON SEQUENCES TO "authenticated";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON SEQUENCES TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON FUNCTIONS TO "postgres";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON FUNCTIONS TO "anon";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON FUNCTIONS TO "authenticated";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON FUNCTIONS TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON TABLES TO "postgres";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON TABLES TO "anon";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON TABLES TO "authenticated";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public"
GRANT ALL ON TABLES TO "service_role";

--
-- Dumped schema changes for auth and storage
--