alter table "public"."tradition_prep_steps" add column "parent_step_id" uuid;

alter table "public"."tradition_prep_steps" add constraint "tradition_prep_steps_parent_step_id_fkey" FOREIGN KEY (parent_step_id) REFERENCES public.tradition_prep_steps(id) ON DELETE SET NULL not valid;

alter table "public"."tradition_prep_steps" validate constraint "tradition_prep_steps_parent_step_id_fkey";


