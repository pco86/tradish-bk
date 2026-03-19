alter table "public"."tradition_prep_steps" add column "step_type" text not null default 'custom'::text;

alter table "public"."tradition_prep_steps" add constraint "tradition_prep_steps_step_type_check" CHECK ((step_type = ANY (ARRAY['default'::text, 'custom'::text]))) not valid;

alter table "public"."tradition_prep_steps" validate constraint "tradition_prep_steps_step_type_check";


