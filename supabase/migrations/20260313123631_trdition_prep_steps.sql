drop policy "Tradition Prep Steps are viewable by everyone" on "public"."tradition_prep_steps";

alter table "public"."tradition_prep_steps" add column "user_id" uuid;

alter table "public"."tradition_prep_steps" add constraint "tradition_prep_steps_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL not valid;

alter table "public"."tradition_prep_steps" validate constraint "tradition_prep_steps_user_id_fkey";


  create policy "If you can view the tradition, you can view the steps"
  on "public"."tradition_prep_steps"
  as permissive
  for select
  to authenticated, anon
using ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE (traditions.id = tradition_prep_steps.tradition_id))));



