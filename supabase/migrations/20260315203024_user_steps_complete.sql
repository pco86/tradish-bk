
  create policy "Creators can update their completion steps"
  on "public"."user_steps_complete"
  as permissive
  for update
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id))
with check ((( SELECT auth.uid() AS uid) = user_id));



  create policy "Users can delete their completion steps"
  on "public"."user_steps_complete"
  as permissive
  for delete
  to authenticated
using ((( SELECT auth.uid() AS uid) = user_id));



