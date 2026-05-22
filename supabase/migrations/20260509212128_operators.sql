
  create table "public"."operators" (
    "id" uuid not null default gen_random_uuid(),
    "event_date_rule_id" uuid not null,
    "type" text not null,
    "config" jsonb not null,
    "sort_order" integer not null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."operators" enable row level security;

CREATE UNIQUE INDEX operators_pkey ON public.operators USING btree (id);

alter table "public"."operators" add constraint "operators_pkey" PRIMARY KEY using index "operators_pkey";

alter table "public"."operators" add constraint "operators_event_date_rule_id_fkey" FOREIGN KEY (event_date_rule_id) REFERENCES public.event_date_rules(id) ON DELETE CASCADE not valid;

alter table "public"."operators" validate constraint "operators_event_date_rule_id_fkey";

grant delete on table "public"."operators" to "anon";

grant insert on table "public"."operators" to "anon";

grant references on table "public"."operators" to "anon";

grant select on table "public"."operators" to "anon";

grant trigger on table "public"."operators" to "anon";

grant truncate on table "public"."operators" to "anon";

grant update on table "public"."operators" to "anon";

grant delete on table "public"."operators" to "authenticated";

grant insert on table "public"."operators" to "authenticated";

grant references on table "public"."operators" to "authenticated";

grant select on table "public"."operators" to "authenticated";

grant trigger on table "public"."operators" to "authenticated";

grant truncate on table "public"."operators" to "authenticated";

grant update on table "public"."operators" to "authenticated";

grant delete on table "public"."operators" to "service_role";

grant insert on table "public"."operators" to "service_role";

grant references on table "public"."operators" to "service_role";

grant select on table "public"."operators" to "service_role";

grant trigger on table "public"."operators" to "service_role";

grant truncate on table "public"."operators" to "service_role";

grant update on table "public"."operators" to "service_role";


  create policy "Operators are viewable for events the user can see."
  on "public"."operators"
  as permissive
  for select
  to authenticated, anon
using ((EXISTS ( SELECT 1
   FROM public.event_date_rules
  WHERE (event_date_rules.id = operators.event_date_rule_id))));



  create policy "Users can create operators on events they own"
  on "public"."operators"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM (public.event_date_rules
     JOIN public.events ON ((events.id = event_date_rules.event_id)))
  WHERE ((event_date_rules.id = operators.event_date_rule_id) AND (( SELECT auth.uid() AS uid) = events.user_id)))));



  create policy "Users can delete operators on events they own"
  on "public"."operators"
  as permissive
  for delete
  to authenticated
using ((EXISTS ( SELECT 1
   FROM (public.event_date_rules
     JOIN public.events ON ((events.id = event_date_rules.event_id)))
  WHERE ((event_date_rules.id = operators.event_date_rule_id) AND (( SELECT auth.uid() AS uid) = events.user_id)))));



  create policy "Users can update operators on events they own"
  on "public"."operators"
  as permissive
  for update
  to authenticated
using ((EXISTS ( SELECT 1
   FROM (public.event_date_rules
     JOIN public.events ON ((events.id = event_date_rules.event_id)))
  WHERE ((event_date_rules.id = operators.event_date_rule_id) AND (( SELECT auth.uid() AS uid) = events.user_id)))))
with check ((EXISTS ( SELECT 1
   FROM (public.event_date_rules
     JOIN public.events ON ((events.id = event_date_rules.event_id)))
  WHERE ((event_date_rules.id = operators.event_date_rule_id) AND (( SELECT auth.uid() AS uid) = events.user_id)))));



