drop policy "Traditions are viewable by everyone" on "public"."traditions";

drop policy "service_insert_traditions" on "public"."traditions";

drop policy "user_insert_traditions" on "public"."traditions";


  create table "public"."user_traditions" (
    "user_id" uuid not null,
    "tradition_id" uuid not null,
    "custom_title" text,
    "notes" text,
    "reminders_enabled" boolean not null default true,
    "notification_time" time without time zone,
    "created_at" timestamp with time zone default now()
      );


alter table "public"."user_traditions" enable row level security;

CREATE UNIQUE INDEX user_traditions_pkey ON public.user_traditions USING btree (user_id, tradition_id);

CREATE INDEX user_traditions_tradition_id_idx ON public.user_traditions USING btree (tradition_id);

alter table "public"."user_traditions" add constraint "user_traditions_pkey" PRIMARY KEY using index "user_traditions_pkey";

alter table "public"."traditions" add constraint "traditions_visibility_creator_check" CHECK ((((visibility = 'system'::text) AND (created_by_user_id IS NULL)) OR ((visibility = ANY (ARRAY['public'::text, 'private'::text])) AND (created_by_user_id IS NOT NULL)))) not valid;

alter table "public"."traditions" validate constraint "traditions_visibility_creator_check";

alter table "public"."user_traditions" add constraint "user_traditions_tradition_id_fkey" FOREIGN KEY (tradition_id) REFERENCES public.traditions(id) ON DELETE CASCADE not valid;

alter table "public"."user_traditions" validate constraint "user_traditions_tradition_id_fkey";

alter table "public"."user_traditions" add constraint "user_traditions_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."user_traditions" validate constraint "user_traditions_user_id_fkey";

grant delete on table "public"."user_traditions" to "anon";

grant insert on table "public"."user_traditions" to "anon";

grant references on table "public"."user_traditions" to "anon";

grant select on table "public"."user_traditions" to "anon";

grant trigger on table "public"."user_traditions" to "anon";

grant truncate on table "public"."user_traditions" to "anon";

grant update on table "public"."user_traditions" to "anon";

grant delete on table "public"."user_traditions" to "authenticated";

grant insert on table "public"."user_traditions" to "authenticated";

grant references on table "public"."user_traditions" to "authenticated";

grant select on table "public"."user_traditions" to "authenticated";

grant trigger on table "public"."user_traditions" to "authenticated";

grant truncate on table "public"."user_traditions" to "authenticated";

grant update on table "public"."user_traditions" to "authenticated";

grant delete on table "public"."user_traditions" to "service_role";

grant insert on table "public"."user_traditions" to "service_role";

grant references on table "public"."user_traditions" to "service_role";

grant select on table "public"."user_traditions" to "service_role";

grant trigger on table "public"."user_traditions" to "service_role";

grant truncate on table "public"."user_traditions" to "service_role";

grant update on table "public"."user_traditions" to "service_role";


  create policy "Admin can delete any traditions"
  on "public"."traditions"
  as permissive
  for delete
  to service_role
using (true);



  create policy "Admin can insert any traditions"
  on "public"."traditions"
  as permissive
  for insert
  to service_role
with check (true);



  create policy "Admin can update any traditions"
  on "public"."traditions"
  as permissive
  for update
  to service_role
using (true)
with check (true);



  create policy "Creators can delete their traditions"
  on "public"."traditions"
  as permissive
  for delete
  to authenticated
using ((( SELECT auth.uid() AS uid) = created_by_user_id));



  create policy "Creators can update their traditions"
  on "public"."traditions"
  as permissive
  for update
  to authenticated
using ((( SELECT auth.uid() AS uid) = created_by_user_id))
with check ((( SELECT auth.uid() AS uid) = created_by_user_id));



  create policy "Creators can view their traditions"
  on "public"."traditions"
  as permissive
  for select
  to authenticated
using ((( SELECT auth.uid() AS uid) = created_by_user_id));



  create policy "Private Traditions are viewable by user"
  on "public"."traditions"
  as permissive
  for select
  to authenticated
using (((visibility = 'private'::text) AND (( SELECT auth.uid() AS uid) = created_by_user_id)));



  create policy "Public Traditions are viewable by everyone"
  on "public"."traditions"
  as permissive
  for select
  to authenticated, anon
using ((visibility = 'public'::text));



  create policy "System Traditions are viewable by everyone"
  on "public"."traditions"
  as permissive
  for select
  to authenticated, anon
using ((visibility = 'system'::text));



  create policy "Users can insert public and private traditions"
  on "public"."traditions"
  as permissive
  for insert
  to public
with check (((visibility = ANY (ARRAY['public'::text, 'private'::text])) AND (( SELECT auth.uid() AS uid) = created_by_user_id)));



  create policy "User traditions are viewable by owner"
  on "public"."user_traditions"
  as permissive
  for select
  to public
using ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can create user traditions"
  on "public"."user_traditions"
  as permissive
  for insert
  to authenticated
with check ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can delete user traditions"
  on "public"."user_traditions"
  as permissive
  for delete
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can update user traditions"
  on "public"."user_traditions"
  as permissive
  for update
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id))
with check ((( SELECT auth.uid() AS uid) = user_id));



