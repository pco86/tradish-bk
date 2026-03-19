drop policy "Occurrences are viewable by everyone" on "public"."tradition_occurrences";


  create policy "Occurrences are viewable based on tradition permissions"
  on "public"."tradition_occurrences"
  as permissive
  for select
  to authenticated, anon
using ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE (traditions.id = tradition_occurrences.tradition_id))));



