
  create table "public"."user_events" (
    "id" uuid not null default gen_random_uuid(),
    "user_id" uuid not null default auth.uid(),
    "event_id" uuid,
    "reminders_enabled" boolean not null default true,
    "notification_time" time without time zone,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."user_events" enable row level security;

CREATE INDEX user_events_event_id_idx ON public.user_events USING btree (event_id);

CREATE UNIQUE INDEX user_events_pkey ON public.user_events USING btree (id);

CREATE UNIQUE INDEX user_events_user_id_event_id_key ON public.user_events USING btree (user_id, event_id);

alter table "public"."user_events" add constraint "user_events_pkey" PRIMARY KEY using index "user_events_pkey";

alter table "public"."user_events" add constraint "user_events_event_id_fkey" FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE not valid;

alter table "public"."user_events" validate constraint "user_events_event_id_fkey";

alter table "public"."user_events" add constraint "user_events_user_id_event_id_key" UNIQUE using index "user_events_user_id_event_id_key";

alter table "public"."user_events" add constraint "user_events_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."user_events" validate constraint "user_events_user_id_fkey";

grant delete on table "public"."user_events" to "anon";

grant insert on table "public"."user_events" to "anon";

grant references on table "public"."user_events" to "anon";

grant select on table "public"."user_events" to "anon";

grant trigger on table "public"."user_events" to "anon";

grant truncate on table "public"."user_events" to "anon";

grant update on table "public"."user_events" to "anon";

grant delete on table "public"."user_events" to "authenticated";

grant insert on table "public"."user_events" to "authenticated";

grant references on table "public"."user_events" to "authenticated";

grant select on table "public"."user_events" to "authenticated";

grant trigger on table "public"."user_events" to "authenticated";

grant truncate on table "public"."user_events" to "authenticated";

grant update on table "public"."user_events" to "authenticated";

grant delete on table "public"."user_events" to "service_role";

grant insert on table "public"."user_events" to "service_role";

grant references on table "public"."user_events" to "service_role";

grant select on table "public"."user_events" to "service_role";

grant trigger on table "public"."user_events" to "service_role";

grant truncate on table "public"."user_events" to "service_role";

grant update on table "public"."user_events" to "service_role";


  create policy "User events are viewable by owner"
  on "public"."user_events"
  as permissive
  for select
  to public
using ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can create user events"
  on "public"."user_events"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can delete user events"
  on "public"."user_events"
  as permissive
  for delete
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can update user events"
  on "public"."user_events"
  as permissive
  for update
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id))
with check ((( SELECT auth.uid() AS uid) = user_id));



