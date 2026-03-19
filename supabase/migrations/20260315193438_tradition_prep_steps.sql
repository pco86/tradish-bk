
  create policy "Creators can update their prep steps"
  on "public"."tradition_prep_steps"
  as permissive
  for update
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id))
with check ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can delete their prep steps"
  on "public"."tradition_prep_steps"
  as permissive
  for delete
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id));



