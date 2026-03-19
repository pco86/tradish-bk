drop policy "User tradition prep completion steps are viewable by owner" on "public"."user_steps_complete";

alter table "public"."user_steps_complete" add column "user_id" uuid default auth.uid();

alter table "public"."user_steps_complete" add constraint "user_steps_complete_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL not valid;

alter table "public"."user_steps_complete" validate constraint "user_steps_complete_user_id_fkey";


  create policy "User tradition prep completion steps are viewable by owner"
  on "public"."user_steps_complete"
  as permissive
  for select
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id));



