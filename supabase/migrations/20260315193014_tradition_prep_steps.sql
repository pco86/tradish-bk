drop policy "If you can view the tradition, you can view the steps" on "public"."tradition_prep_steps";


  create policy "You can view your steps and default steps."
  on "public"."tradition_prep_steps"
  as permissive
  for select
  to authenticated, anon
using ((((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE (traditions.id = tradition_prep_steps.tradition_id))) AND (step_type = 'default'::text)) OR ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE (traditions.id = tradition_prep_steps.tradition_id))) AND (user_id = ( SELECT auth.uid() AS uid)))));



