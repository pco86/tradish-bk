alter table "public"."traditions" add column "created_by_user_id" uuid;

alter table "public"."traditions" add column "visibility" text not null default 'private'::text;

alter table "public"."traditions" add constraint "traditions_created_by_user_id_fkey" FOREIGN KEY (created_by_user_id) REFERENCES auth.users(id) ON DELETE SET NULL not valid;

alter table "public"."traditions" validate constraint "traditions_created_by_user_id_fkey";

alter table "public"."traditions" add constraint "traditions_visibility_check" CHECK ((visibility = ANY (ARRAY['system'::text, 'public'::text, 'private'::text]))) not valid;

alter table "public"."traditions" validate constraint "traditions_visibility_check";


  create policy "service_insert_traditions"
  on "public"."traditions"
  as permissive
  for insert
  to service_role
with check (true);



  create policy "user_insert_traditions"
  on "public"."traditions"
  as permissive
  for insert
  to public
with check (((visibility = ANY (ARRAY['public'::text, 'private'::text])) AND (created_by_user_id = auth.uid())));

