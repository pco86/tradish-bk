alter table "public"."user_steps_complete" drop constraint "user_steps_complete_occurrence_id_step_id_key";

alter table "public"."user_steps_complete" drop constraint "user_steps_complete_user_id_fkey";

drop index if exists "public"."user_steps_complete_occurrence_id_step_id_key";

alter table "public"."user_steps_complete" drop column "is_completed";

alter table "public"."user_steps_complete" add column "is_complete" boolean not null default true;

alter table "public"."user_steps_complete" alter column "user_id" set not null;

CREATE UNIQUE INDEX user_steps_complete_occurrence_id_step_id_user_id_key ON public.user_steps_complete USING btree (occurrence_id, step_id, user_id);

alter table "public"."user_steps_complete" add constraint "user_steps_complete_occurrence_id_step_id_user_id_key" UNIQUE using index "user_steps_complete_occurrence_id_step_id_user_id_key";

alter table "public"."user_steps_complete" add constraint "user_steps_complete_user_id_fkey" FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE not valid;

alter table "public"."user_steps_complete" validate constraint "user_steps_complete_user_id_fkey";


