
  create table "public"."events" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid default auth.uid(),
    "title" text not null,
    "visibility" text not null default 'private'::text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now(),
    "deleted_at" timestamp with time zone
      );


alter table "public"."events" enable row level security;

CREATE UNIQUE INDEX events_pkey ON public.events USING btree (id);

alter table "public"."events" add constraint "events_pkey" PRIMARY KEY using index "events_pkey";

alter table "public"."events" add constraint "event_visibility_creator_check" CHECK ((((visibility = 'system'::text) AND (user_id IS NULL)) OR ((visibility = 'private'::text) AND (user_id IS NOT NULL)))) not valid;

alter table "public"."events" validate constraint "event_visibility_creator_check";

alter table "public"."events" add constraint "events_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL not valid;

alter table "public"."events" validate constraint "events_user_id_fkey";

alter table "public"."events" add constraint "events_visibility_check" CHECK ((visibility = ANY (ARRAY['system'::text, 'private'::text]))) not valid;

alter table "public"."events" validate constraint "events_visibility_check";

grant delete on table "public"."events" to "anon";

grant insert on table "public"."events" to "anon";

grant references on table "public"."events" to "anon";

grant select on table "public"."events" to "anon";

grant trigger on table "public"."events" to "anon";

grant truncate on table "public"."events" to "anon";

grant update on table "public"."events" to "anon";

grant delete on table "public"."events" to "authenticated";

grant insert on table "public"."events" to "authenticated";

grant references on table "public"."events" to "authenticated";

grant select on table "public"."events" to "authenticated";

grant trigger on table "public"."events" to "authenticated";

grant truncate on table "public"."events" to "authenticated";

grant update on table "public"."events" to "authenticated";

grant delete on table "public"."events" to "service_role";

grant insert on table "public"."events" to "service_role";

grant references on table "public"."events" to "service_role";

grant select on table "public"."events" to "service_role";

grant trigger on table "public"."events" to "service_role";

grant truncate on table "public"."events" to "service_role";

grant update on table "public"."events" to "service_role";


  create policy "Admin can delete any events"
  on "public"."events"
  as permissive
  for delete
  to service_role
using (true);



  create policy "Admin can insert any event"
  on "public"."events"
  as permissive
  for insert
  to service_role
with check (true);



  create policy "Admin can update any event"
  on "public"."events"
  as permissive
  for update
  to service_role
using (true)
with check (true);



  create policy "Creators can update their events"
  on "public"."events"
  as permissive
  for update
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id))
with check (((visibility = 'private'::text) AND (( SELECT auth.uid() AS uid) = user_id)));



  create policy "Event selection rules"
  on "public"."events"
  as permissive
  for select
  to authenticated, anon
using (((visibility = 'system'::text) OR (( SELECT auth.uid() AS uid) = user_id)));



  create policy "Users can delete their events"
  on "public"."events"
  as permissive
  for delete
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can insert public and private events"
  on "public"."events"
  as permissive
  for insert
  to public
with check (((visibility = 'private'::text) AND (( SELECT auth.uid() AS uid) = user_id)));



