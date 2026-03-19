drop policy "Creators can update their completion date rules" on "public"."tradition_date_rules";

drop policy "Users can create date rules on traditions they own" on "public"."tradition_date_rules";

drop policy "Users can delete their date rules" on "public"."tradition_date_rules";


  create policy "Creators can update their completion date rules"
  on "public"."tradition_date_rules"
  as permissive
  for update
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE ((( SELECT auth.uid() AS uid) = traditions.user_id) AND (traditions.id = tradition_date_rules.tradition_id)))))
with check ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE ((( SELECT auth.uid() AS uid) = traditions.user_id) AND (traditions.id = tradition_date_rules.tradition_id)))));



  create policy "Users can create date rules on traditions they own"
  on "public"."tradition_date_rules"
  as permissive
  for insert
  to authenticated
with check ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE ((( SELECT auth.uid() AS uid) = traditions.user_id) AND (traditions.id = tradition_date_rules.tradition_id)))));



  create policy "Users can delete their date rules"
  on "public"."tradition_date_rules"
  as permissive
  for delete
  to authenticated
using ((EXISTS ( SELECT 1
   FROM public.traditions
  WHERE ((( SELECT auth.uid() AS uid) = traditions.user_id) AND (traditions.id = tradition_date_rules.tradition_id)))));



