drop policy "Creators can update their traditions" on "public"."traditions";


  create policy "Creators can update their traditions"
  on "public"."traditions"
  as permissive
  for update
  to authenticated
using (((visibility = ANY (ARRAY['public'::text, 'private'::text])) AND (( SELECT auth.uid() AS uid) = user_id)))
with check (((visibility = ANY (ARRAY['public'::text, 'private'::text])) AND (( SELECT auth.uid() AS uid) = user_id)));



