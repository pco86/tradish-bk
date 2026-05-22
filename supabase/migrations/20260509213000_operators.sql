drop policy "Operators are viewable for events the user can see." on "public"."operators";

drop policy "Users can create operators on events they own" on "public"."operators";

drop policy "Users can delete operators on events they own" on "public"."operators";

drop policy "Users can update operators on events they own" on "public"."operators";

revoke delete on table "public"."operators" from "anon";

revoke insert on table "public"."operators" from "anon";

revoke references on table "public"."operators" from "anon";

revoke select on table "public"."operators" from "anon";

revoke trigger on table "public"."operators" from "anon";

revoke truncate on table "public"."operators" from "anon";

revoke update on table "public"."operators" from "anon";

revoke delete on table "public"."operators" from "authenticated";

revoke insert on table "public"."operators" from "authenticated";

revoke references on table "public"."operators" from "authenticated";

revoke select on table "public"."operators" from "authenticated";

revoke trigger on table "public"."operators" from "authenticated";

revoke truncate on table "public"."operators" from "authenticated";

revoke update on table "public"."operators" from "authenticated";

revoke delete on table "public"."operators" from "service_role";

revoke insert on table "public"."operators" from "service_role";

revoke references on table "public"."operators" from "service_role";

revoke select on table "public"."operators" from "service_role";

revoke trigger on table "public"."operators" from "service_role";

revoke truncate on table "public"."operators" from "service_role";

revoke update on table "public"."operators" from "service_role";

alter table "public"."operators" drop constraint "operators_event_date_rule_id_fkey";

alter table "public"."operators" drop constraint "operators_pkey";

drop index if exists "public"."operators_pkey";

drop table "public"."operators";


  create table "public"."event_date_rule_operations" (
    "id" uuid not null default gen_random_uuid(),
    "event_date_rule_id" uuid not null,
    "type" text not null,
    "config" jsonb not null,
    "sort_order" integer not null,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."event_date_rule_operations" enable row level security;

CREATE UNIQUE INDEX event_date_rule_operations_pkey ON public.event_date_rule_operations USING btree (id);

alter table "public"."event_date_rule_operations" add constraint "event_date_rule_operations_pkey" PRIMARY KEY using index "event_date_rule_operations_pkey";

alter table "public"."event_date_rule_operations" add constraint "event_date_rule_operations_event_date_rule_id_fkey" FOREIGN KEY (event_date_rule_id) REFERENCES public.event_date_rules(id) ON DELETE CASCADE not valid;

alter table "public"."event_date_rule_operations" validate constraint "event_date_rule_operations_event_date_rule_id_fkey";

grant delete on table "public"."event_date_rule_operations" to "anon";

grant insert on table "public"."event_date_rule_operations" to "anon";

grant references on table "public"."event_date_rule_operations" to "anon";

grant select on table "public"."event_date_rule_operations" to "anon";

grant trigger on table "public"."event_date_rule_operations" to "anon";

grant truncate on table "public"."event_date_rule_operations" to "anon";

grant update on table "public"."event_date_rule_operations" to "anon";

grant delete on table "public"."event_date_rule_operations" to "authenticated";

grant insert on table "public"."event_date_rule_operations" to "authenticated";

grant references on table "public"."event_date_rule_operations" to "authenticated";

grant select on table "public"."event_date_rule_operations" to "authenticated";

grant trigger on table "public"."event_date_rule_operations" to "authenticated";

grant truncate on table "public"."event_date_rule_operations" to "authenticated";

grant update on table "public"."event_date_rule_operations" to "authenticated";

grant delete on table "public"."event_date_rule_operations" to "service_role";

grant insert on table "public"."event_date_rule_operations" to "service_role";

grant references on table "public"."event_date_rule_operations" to "service_role";

grant select on table "public"."event_date_rule_operations" to "service_role";

grant trigger on table "public"."event_date_rule_operations" to "service_role";

grant truncate on table "public"."event_date_rule_operations" to "service_role";

grant update on table "public"."event_date_rule_operations" to "service_role";


  create policy "Event date rule operations are viewable for events the user can"
  on "public"."event_date_rule_operations"
  as permissive
  for select
  to authenticated, anon
using ((EXISTS ( SELECT 1
   FROM public.event_date_rules
  WHERE (event_date_rules.id = event_date_rule_operations.event_date_rule_id))));



  create policy "Users can create event date rule operations on events they own"
  on "public"."event_date_rule_operations"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM (public.event_date_rules
     JOIN public.events ON ((events.id = event_date_rules.event_id)))
  WHERE ((event_date_rules.id = event_date_rule_operations.event_date_rule_id) AND (( SELECT auth.uid() AS uid) = events.user_id)))));



  create policy "Users can delete event date rule operations on events they own"
  on "public"."event_date_rule_operations"
  as permissive
  for delete
  to authenticated
using ((EXISTS ( SELECT 1
   FROM (public.event_date_rules
     JOIN public.events ON ((events.id = event_date_rules.event_id)))
  WHERE ((event_date_rules.id = event_date_rule_operations.event_date_rule_id) AND (( SELECT auth.uid() AS uid) = events.user_id)))));



  create policy "Users can update event date rule operations on events they own"
  on "public"."event_date_rule_operations"
  as permissive
  for update
  to authenticated
using ((EXISTS ( SELECT 1
   FROM (public.event_date_rules
     JOIN public.events ON ((events.id = event_date_rules.event_id)))
  WHERE ((event_date_rules.id = event_date_rule_operations.event_date_rule_id) AND (( SELECT auth.uid() AS uid) = events.user_id)))))
with check ((EXISTS ( SELECT 1
   FROM (public.event_date_rules
     JOIN public.events ON ((events.id = event_date_rules.event_id)))
  WHERE ((event_date_rules.id = event_date_rule_operations.event_date_rule_id) AND (( SELECT auth.uid() AS uid) = events.user_id)))));



