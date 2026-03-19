
  create policy "Users can create steps on favorited and owned traditions"
  on "public"."tradition_prep_steps"
  as permissive
  for insert
  to authenticated
with check ((((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1
   FROM public.traditions
  WHERE ((traditions.id = tradition_prep_steps.tradition_id) AND (traditions.user_id = ( SELECT auth.uid() AS uid)))))) OR ((( SELECT auth.uid() AS uid) = user_id) AND (EXISTS ( SELECT 1
   FROM public.user_traditions ut
  WHERE (ut.tradition_id = tradition_prep_steps.tradition_id))) AND (step_type = 'custom'::text))));



