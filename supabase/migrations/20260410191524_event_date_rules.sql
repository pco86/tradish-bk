
  create table "public"."event_date_rules" (
    "id" uuid not null default gen_random_uuid(),
    "event_id" uuid not null,
    "rule_type" text,
    "algorithm" text,
    "frequency" text,
    "operations" text[],
    "calendar_type" text default 'gregorian'::text,
    "relative_event_id" uuid,
    "month" integer,
    "day" integer,
    "weekday" integer,
    "week_of_month" integer,
    "interval" integer,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."event_date_rules" enable row level security;

CREATE UNIQUE INDEX event_date_rules_event_id_key ON public.event_date_rules USING btree (event_id);

CREATE UNIQUE INDEX event_date_rules_pkey ON public.event_date_rules USING btree (id);

alter table "public"."event_date_rules" add constraint "event_date_rules_pkey" PRIMARY KEY using index "event_date_rules_pkey";

alter table "public"."event_date_rules" add constraint "event_date_rules_algorithm_check" CHECK ((algorithm = 'easter-western'::text)) not valid;

alter table "public"."event_date_rules" validate constraint "event_date_rules_algorithm_check";

alter table "public"."event_date_rules" add constraint "event_date_rules_calendar_type_check" CHECK ((calendar_type = ANY (ARRAY['gregorian'::text, 'lunar'::text, 'hebrew'::text, 'islamic'::text, 'chinese'::text]))) not valid;

alter table "public"."event_date_rules" validate constraint "event_date_rules_calendar_type_check";

alter table "public"."event_date_rules" add constraint "event_date_rules_event_id_fkey" FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE not valid;

alter table "public"."event_date_rules" validate constraint "event_date_rules_event_id_fkey";

alter table "public"."event_date_rules" add constraint "event_date_rules_event_id_key" UNIQUE using index "event_date_rules_event_id_key";

alter table "public"."event_date_rules" add constraint "event_date_rules_frequency_check" CHECK ((frequency = ANY (ARRAY['weekly'::text, 'monthly'::text, 'yearly'::text]))) not valid;

alter table "public"."event_date_rules" validate constraint "event_date_rules_frequency_check";

alter table "public"."event_date_rules" add constraint "event_date_rules_relative_event_id_fkey" FOREIGN KEY (relative_event_id) REFERENCES public.events(id) not valid;

alter table "public"."event_date_rules" validate constraint "event_date_rules_relative_event_id_fkey";

alter table "public"."event_date_rules" add constraint "event_date_rules_rule_type_check" CHECK ((rule_type = ANY (ARRAY['fixed'::text, 'relative'::text, 'computed'::text, 'weekly'::text]))) not valid;

alter table "public"."event_date_rules" validate constraint "event_date_rules_rule_type_check";

grant delete on table "public"."event_date_rules" to "anon";

grant insert on table "public"."event_date_rules" to "anon";

grant references on table "public"."event_date_rules" to "anon";

grant select on table "public"."event_date_rules" to "anon";

grant trigger on table "public"."event_date_rules" to "anon";

grant truncate on table "public"."event_date_rules" to "anon";

grant update on table "public"."event_date_rules" to "anon";

grant delete on table "public"."event_date_rules" to "authenticated";

grant insert on table "public"."event_date_rules" to "authenticated";

grant references on table "public"."event_date_rules" to "authenticated";

grant select on table "public"."event_date_rules" to "authenticated";

grant trigger on table "public"."event_date_rules" to "authenticated";

grant truncate on table "public"."event_date_rules" to "authenticated";

grant update on table "public"."event_date_rules" to "authenticated";

grant delete on table "public"."event_date_rules" to "service_role";

grant insert on table "public"."event_date_rules" to "service_role";

grant references on table "public"."event_date_rules" to "service_role";

grant select on table "public"."event_date_rules" to "service_role";

grant trigger on table "public"."event_date_rules" to "service_role";

grant truncate on table "public"."event_date_rules" to "service_role";

grant update on table "public"."event_date_rules" to "service_role";


  create policy "Creators can update their date rules"
  on "public"."event_date_rules"
  as permissive
  for update
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.events
  WHERE ((( SELECT auth.uid() AS uid) = events.user_id) AND (events.id = event_date_rules.event_id)))))
with check ((EXISTS ( SELECT 1
   FROM public.events
  WHERE ((( SELECT auth.uid() AS uid) = events.user_id) AND (events.id = event_date_rules.event_id)))));



  create policy "Date Rules are viewable for events that can be seen"
  on "public"."event_date_rules"
  as permissive
  for select
  to authenticated, anon
using ((EXISTS ( SELECT 1
   FROM public.events
  WHERE (events.id = event_date_rules.event_id))));



  create policy "Users can create date rules on events they own"
  on "public"."event_date_rules"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM public.events
  WHERE ((( SELECT auth.uid() AS uid) = events.user_id) AND (events.id = event_date_rules.event_id)))));



  create policy "Users can delete their date rules"
  on "public"."event_date_rules"
  as permissive
  for delete
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.events
  WHERE ((( SELECT auth.uid() AS uid) = events.user_id) AND (events.id = event_date_rules.event_id)))));



