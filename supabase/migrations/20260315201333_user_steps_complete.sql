drop policy "User tradition prep completion steps are viewable by owner" on "public"."user_steps_complete";

drop policy "User tradition prep steps are viewable by owner" on "public"."user_tradition_prep_steps";

drop policy "Users can create user tradition prep steps" on "public"."user_tradition_prep_steps";

drop policy "Users can delete user tradition prep steps" on "public"."user_tradition_prep_steps";

drop policy "Users can update user tradition prep steps" on "public"."user_tradition_prep_steps";

revoke delete on table "public"."user_tradition_prep_steps" from "anon";

revoke insert on table "public"."user_tradition_prep_steps" from "anon";

revoke references on table "public"."user_tradition_prep_steps" from "anon";

revoke select on table "public"."user_tradition_prep_steps" from "anon";

revoke trigger on table "public"."user_tradition_prep_steps" from "anon";

revoke truncate on table "public"."user_tradition_prep_steps" from "anon";

revoke update on table "public"."user_tradition_prep_steps" from "anon";

revoke delete on table "public"."user_tradition_prep_steps" from "authenticated";

revoke insert on table "public"."user_tradition_prep_steps" from "authenticated";

revoke references on table "public"."user_tradition_prep_steps" from "authenticated";

revoke select on table "public"."user_tradition_prep_steps" from "authenticated";

revoke trigger on table "public"."user_tradition_prep_steps" from "authenticated";

revoke truncate on table "public"."user_tradition_prep_steps" from "authenticated";

revoke update on table "public"."user_tradition_prep_steps" from "authenticated";

revoke delete on table "public"."user_tradition_prep_steps" from "service_role";

revoke insert on table "public"."user_tradition_prep_steps" from "service_role";

revoke references on table "public"."user_tradition_prep_steps" from "service_role";

revoke select on table "public"."user_tradition_prep_steps" from "service_role";

revoke trigger on table "public"."user_tradition_prep_steps" from "service_role";

revoke truncate on table "public"."user_tradition_prep_steps" from "service_role";

revoke update on table "public"."user_tradition_prep_steps" from "service_role";

alter table "public"."user_steps_complete" drop constraint "user_steps_complete_occurrence_id_user_step_id_key";

alter table "public"."user_steps_complete" drop constraint "user_steps_complete_user_step_id_fkey";

alter table "public"."user_tradition_prep_steps" drop constraint "user_tradition_prep_steps_tradition_prep_step_id_fkey";

alter table "public"."user_tradition_prep_steps" drop constraint "user_tradition_prep_steps_user_tradition_id_fkey";

alter table "public"."user_tradition_prep_steps" drop constraint "user_tradition_prep_steps_user_tradition_id_fkey1";

alter table "public"."user_tradition_prep_steps" drop constraint "user_tradition_prep_steps_user_tradition_id_tradition_prep__key";

alter table "public"."user_tradition_prep_steps" drop constraint "user_tradition_prep_steps_pkey";

drop index if exists "public"."user_steps_complete_occurrence_id_user_step_id_key";

drop index if exists "public"."user_tradition_prep_steps_pkey";

drop index if exists "public"."user_tradition_prep_steps_user_tradition_id_tradition_prep__key";

drop table "public"."user_tradition_prep_steps";

alter table "public"."user_steps_complete" drop column "completed_at";

alter table "public"."user_steps_complete" drop column "user_step_id";

alter table "public"."user_steps_complete" add column "step_id" uuid not null;

alter table "public"."user_steps_complete" alter column "is_completed" set default true;

CREATE UNIQUE INDEX user_steps_complete_occurrence_id_step_id_key ON public.user_steps_complete USING btree (occurrence_id, step_id);

alter table "public"."user_steps_complete" add constraint "user_steps_complete_occurrence_id_step_id_key" UNIQUE using index "user_steps_complete_occurrence_id_step_id_key";

alter table "public"."user_steps_complete" add constraint "user_steps_complete_step_id_fkey" FOREIGN KEY (step_id) REFERENCES public.tradition_prep_steps(id) ON DELETE CASCADE not valid;

alter table "public"."user_steps_complete" validate constraint "user_steps_complete_step_id_fkey";


