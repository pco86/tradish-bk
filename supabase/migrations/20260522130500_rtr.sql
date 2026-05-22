
  create table "public"."rule_type_requirements" (
    "rule_type" text not null,
    "required_fields" text[]
      );


CREATE UNIQUE INDEX rule_type_requirements_pkey ON public.rule_type_requirements USING btree (rule_type);

alter table "public"."rule_type_requirements" add constraint "rule_type_requirements_pkey" PRIMARY KEY using index "rule_type_requirements_pkey";

grant delete on table "public"."rule_type_requirements" to "anon";

grant insert on table "public"."rule_type_requirements" to "anon";

grant references on table "public"."rule_type_requirements" to "anon";

grant select on table "public"."rule_type_requirements" to "anon";

grant trigger on table "public"."rule_type_requirements" to "anon";

grant truncate on table "public"."rule_type_requirements" to "anon";

grant update on table "public"."rule_type_requirements" to "anon";

grant delete on table "public"."rule_type_requirements" to "authenticated";

grant insert on table "public"."rule_type_requirements" to "authenticated";

grant references on table "public"."rule_type_requirements" to "authenticated";

grant select on table "public"."rule_type_requirements" to "authenticated";

grant trigger on table "public"."rule_type_requirements" to "authenticated";

grant truncate on table "public"."rule_type_requirements" to "authenticated";

grant update on table "public"."rule_type_requirements" to "authenticated";

grant delete on table "public"."rule_type_requirements" to "service_role";

grant insert on table "public"."rule_type_requirements" to "service_role";

grant references on table "public"."rule_type_requirements" to "service_role";

grant select on table "public"."rule_type_requirements" to "service_role";

grant trigger on table "public"."rule_type_requirements" to "service_role";

grant truncate on table "public"."rule_type_requirements" to "service_role";

grant update on table "public"."rule_type_requirements" to "service_role";


