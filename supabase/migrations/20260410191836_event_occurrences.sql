
  create table "public"."event_occurrences" (
    "id" uuid not null default gen_random_uuid(),
    "event_id" uuid not null,
    "occurs_on" text,
    "created_at" timestamp with time zone not null default now(),
    "updated_at" timestamp with time zone not null default now()
      );


alter table "public"."event_occurrences" enable row level security;

CREATE UNIQUE INDEX event_occurrences_event_id_occurs_on_key ON public.event_occurrences USING btree (event_id, occurs_on);

CREATE UNIQUE INDEX event_occurrences_pkey ON public.event_occurrences USING btree (id);

alter table "public"."event_occurrences" add constraint "event_occurrences_pkey" PRIMARY KEY using index "event_occurrences_pkey";

alter table "public"."event_occurrences" add constraint "event_occurrences_event_id_fkey" FOREIGN KEY (event_id) REFERENCES public.events(id) ON DELETE CASCADE not valid;

alter table "public"."event_occurrences" validate constraint "event_occurrences_event_id_fkey";

alter table "public"."event_occurrences" add constraint "event_occurrences_event_id_occurs_on_key" UNIQUE using index "event_occurrences_event_id_occurs_on_key";

grant delete on table "public"."event_occurrences" to "anon";

grant insert on table "public"."event_occurrences" to "anon";

grant references on table "public"."event_occurrences" to "anon";

grant select on table "public"."event_occurrences" to "anon";

grant trigger on table "public"."event_occurrences" to "anon";

grant truncate on table "public"."event_occurrences" to "anon";

grant update on table "public"."event_occurrences" to "anon";

grant delete on table "public"."event_occurrences" to "authenticated";

grant insert on table "public"."event_occurrences" to "authenticated";

grant references on table "public"."event_occurrences" to "authenticated";

grant select on table "public"."event_occurrences" to "authenticated";

grant trigger on table "public"."event_occurrences" to "authenticated";

grant truncate on table "public"."event_occurrences" to "authenticated";

grant update on table "public"."event_occurrences" to "authenticated";

grant delete on table "public"."event_occurrences" to "service_role";

grant insert on table "public"."event_occurrences" to "service_role";

grant references on table "public"."event_occurrences" to "service_role";

grant select on table "public"."event_occurrences" to "service_role";

grant trigger on table "public"."event_occurrences" to "service_role";

grant truncate on table "public"."event_occurrences" to "service_role";

grant update on table "public"."event_occurrences" to "service_role";


  create policy "Occurrences are viewable based on event permissions"
  on "public"."event_occurrences"
  as permissive
  for select
  to authenticated, anon
using ((EXISTS ( SELECT 1
   FROM public.events
  WHERE (events.id = event_occurrences.event_id))));



