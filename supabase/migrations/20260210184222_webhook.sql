CREATE TRIGGER hello_webhook AFTER INSERT ON public.traditions FOR EACH ROW EXECUTE FUNCTION supabase_functions.http_request('http://host.docker.internal:54321/functions/v1/hello-webhook', 'POST', '{"Content-Type":"application/json"}', '{}', '1000');


