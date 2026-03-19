drop policy "User tradition prep completion steps are viewable by owner" on "public"."user_steps_complete";


  create policy "Users can complete steps they can view."
  on "public"."user_steps_complete"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM public.tradition_prep_steps
  WHERE (user_steps_complete.step_id = tradition_prep_steps.id))));



  create policy "User tradition prep completion steps are viewable by owner"
  on "public"."user_steps_complete"
  as permissive
  for select
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.tradition_prep_steps tps
  WHERE (tps.id = user_steps_complete.step_id))));



