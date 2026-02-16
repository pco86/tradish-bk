drop policy "Creators can view their traditions" on "public"."traditions";

drop policy "Private Traditions are viewable by user" on "public"."traditions";

drop policy "Public Traditions are viewable by everyone" on "public"."traditions";

drop policy "System Traditions are viewable by everyone" on "public"."traditions";


  create policy "Tradition selection rules"
  on "public"."traditions"
  as permissive
  for select
  to authenticated, anon
using (((visibility = ANY (ARRAY['system'::text, 'public'::text])) OR (( SELECT auth.uid() AS uid) = created_by_user_id)));



