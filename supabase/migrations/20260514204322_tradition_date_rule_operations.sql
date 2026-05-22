
  create table "public"."tradition_date_rule_operations" (
    "id" uuid not null default gen_random_uuid(),
    "tradition_id" uuid not null,
    "type" text not null,
    "config" jsonb not null,
    "sort_order" integer not null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."tradition_date_rule_operations" enable row level security;

CREATE UNIQUE INDEX tradition_date_rule_operations_pkey ON public.tradition_date_rule_operations USING btree (id);

alter table "public"."tradition_date_rule_operations" add constraint "tradition_date_rule_operations_pkey" PRIMARY KEY using index "tradition_date_rule_operations_pkey";

alter table "public"."tradition_date_rule_operations" add constraint "tradition_date_rule_operations_tradition_id_fkey" FOREIGN KEY (tradition_id) REFERENCES public.traditions(id) ON DELETE CASCADE not valid;

alter table "public"."tradition_date_rule_operations" validate constraint "tradition_date_rule_operations_tradition_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.copy_steps_on_favorite()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    INSERT INTO user_tradition_prep_steps(user_tradition_id,
	tradition_prep_step_id, sort_order)
    SELECT
        NEW.id,
        id,
        sort_order
    FROM
        tradition_prep_steps
    WHERE
        tradition_id = NEW.parent_tradition_id;
    RETURN new;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.copy_tradition_on_favorite()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
DECLARE
    new_id uuid;
BEGIN
    INSERT INTO traditions(user_id, title, short_description, long_description,
	notes, visibility)
    SELECT
        auth.uid(),
        title,
        short_description,
        long_description,
        notes,
        'private'
    FROM
        traditions
    WHERE
        id = NEW.parent_tradition_id
    RETURNING
        id
    INTO
        new_id;
    NEW.tradition_id := new_id;
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.excute_add_occurrences_new_event()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    webhook_url text;
    api_key text;
    -- Define other variables if needed
BEGIN
    -- Retrieve the secret values from the vault.decrypted_secrets view
    SELECT
        decrypted_secret
    INTO
        webhook_url
    FROM
        vault.decrypted_secrets
    WHERE
        name = 'add_occurrences_new_event';
    SELECT
        decrypted_secret
    INTO
        api_key
    FROM
        vault.decrypted_secrets
    WHERE
        name = 'webhook_secret';
    IF webhook_url IS NULL THEN
        RETURN NULL;
    END IF;
    IF api_key IS NULL THEN
        RETURN NULL;
    END IF;
    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    -- This triggers an edge function which creates the occurrences in the db.
    PERFORM
	net.http_post(url := webhook_url, body := to_jsonb(NEW), headers :=
	    jsonb_build_object('Content-Type', 'application/json',
	    'X-Webhook-Secret', 'Bearer ' || api_key));
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.excute_add_occurrences_new_tradition()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    webhook_url text;
    api_key text;
    -- Define other variables if needed
BEGIN
    -- Retrieve the secret values from the vault.decrypted_secrets view
    SELECT
        decrypted_secret
    INTO
        webhook_url
    FROM
        vault.decrypted_secrets
    WHERE
        name = 'add_occurrences_new_tradition';
    SELECT
        decrypted_secret
    INTO
        api_key
    FROM
        vault.decrypted_secrets
    WHERE
        name = 'webhook_secret';
    IF webhook_url IS NULL THEN
        RETURN NULL;
    END IF;
    IF api_key IS NULL THEN
        RETURN NULL;
    END IF;
    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    -- This triggers an edge function which creates the occurrences in the db.
    PERFORM
	net.http_post(url := webhook_url, body := to_jsonb(NEW), headers :=
	    jsonb_build_object('Content-Type', 'application/json', 'X-Webhook-Secret',
	    'Bearer ' || api_key));
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.set_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.updated_at = NOW();
    RETURN new;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.tradition_owner_user_tradition()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    IF auth.uid() IS NULL THEN
        RETURN NULL;
    END IF;
    INSERT INTO user_traditions(user_id, tradition_id)
        VALUES(auth.uid(), NEW.id);
    RETURN NEW;
END;
$function$
;

grant delete on table "public"."tradition_date_rule_operations" to "anon";

grant insert on table "public"."tradition_date_rule_operations" to "anon";

grant references on table "public"."tradition_date_rule_operations" to "anon";

grant select on table "public"."tradition_date_rule_operations" to "anon";

grant trigger on table "public"."tradition_date_rule_operations" to "anon";

grant truncate on table "public"."tradition_date_rule_operations" to "anon";

grant update on table "public"."tradition_date_rule_operations" to "anon";

grant delete on table "public"."tradition_date_rule_operations" to "authenticated";

grant insert on table "public"."tradition_date_rule_operations" to "authenticated";

grant references on table "public"."tradition_date_rule_operations" to "authenticated";

grant select on table "public"."tradition_date_rule_operations" to "authenticated";

grant trigger on table "public"."tradition_date_rule_operations" to "authenticated";

grant truncate on table "public"."tradition_date_rule_operations" to "authenticated";

grant update on table "public"."tradition_date_rule_operations" to "authenticated";

grant delete on table "public"."tradition_date_rule_operations" to "service_role";

grant insert on table "public"."tradition_date_rule_operations" to "service_role";

grant references on table "public"."tradition_date_rule_operations" to "service_role";

grant select on table "public"."tradition_date_rule_operations" to "service_role";

grant trigger on table "public"."tradition_date_rule_operations" to "service_role";

grant truncate on table "public"."tradition_date_rule_operations" to "service_role";

grant update on table "public"."tradition_date_rule_operations" to "service_role";


  create policy "Tradition date rule operations are viewable for traditions the "
  on "public"."tradition_date_rule_operations"
  as permissive
  for select
  to authenticated, anon
using ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE (traditions.id = tradition_date_rule_operations.tradition_id))));



  create policy "Users can create tradition date rule operations on traditions t"
  on "public"."tradition_date_rule_operations"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE ((traditions.id = tradition_date_rule_operations.tradition_id) AND (( SELECT auth.uid() AS uid) = traditions.user_id)))));



  create policy "Users can delete tradition date rule operations on traditions t"
  on "public"."tradition_date_rule_operations"
  as permissive
  for delete
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE ((traditions.id = tradition_date_rule_operations.tradition_id) AND (( SELECT auth.uid() AS uid) = traditions.user_id)))));



  create policy "Users can update tradition date rule operations on traditions
 "
  on "public"."tradition_date_rule_operations"
  as permissive
  for update
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE ((traditions.id = tradition_date_rule_operations.tradition_id) AND (( SELECT auth.uid() AS uid) = traditions.user_id)))))
with check ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE ((traditions.id = tradition_date_rule_operations.tradition_id) AND (( SELECT auth.uid() AS uid) = traditions.user_id)))));


CREATE TRIGGER event_date_operations_updated BEFORE UPDATE ON public.event_date_rule_operations FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER tradition_date_operations_updated BEFORE UPDATE ON public.tradition_date_rule_operations FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


