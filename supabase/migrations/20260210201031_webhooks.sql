drop trigger if exists "hello_webhook" on "public"."traditions";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.traditions_webhook_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  perform supabase_functions.http_request(
    'http://host.docker.internal:54321/functions/v1/hello-webhook',
    'POST',
    format(
      '{"Content-Type":"application/json","Authorization":"Bearer %s"}',
      current_setting('app.webhook_secret', true)
    ),
    row_to_json(NEW)::text,
    '1000'
  );

  return NEW;
end;
$function$
;

CREATE TRIGGER hello_webhook AFTER INSERT ON public.traditions FOR EACH ROW EXECUTE FUNCTION public.traditions_webhook_trigger();


