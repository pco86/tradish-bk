
  create policy "Date Rules are viewable by everyone"
  on "public"."tradition_date_rules"
  as permissive
  for select
  to authenticated, anon
using (true);



