alter table "public"."traditions" add constraint "traditions_visibility_creator_check" CHECK ((((visibility = 'system'::text) AND (created_by_user_id IS NULL)) OR ((visibility = ANY (ARRAY['public'::text, 'private'::text])) AND (created_by_user_id IS NOT NULL)))) not valid;

alter table "public"."traditions" validate constraint "traditions_visibility_creator_check";


