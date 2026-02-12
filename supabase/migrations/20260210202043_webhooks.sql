set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.traditions_webhook_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
  perform extensions.http_request(
    'http://host.docker.internal:54321/functions/v1/hello-webhook'::text,
    'POST'::text,
    format(
      '{"Content-Type":"application/json","Authorization":"Bearer %s"}',
      current_setting('app.webhook_secret', true)
    )::text,
    row_to_json(NEW)::text,
    1000::integer
  );

  return NEW;
end;
$function$
;


