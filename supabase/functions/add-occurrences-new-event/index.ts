// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "@supabase/functions-js/edge-runtime.d.ts";
import { Tables } from "../../../database.types.ts";
import { materializeEventOccurrences } from "../_shared/utils.ts";
import {
  deleteEventOccurrences,
  upsertEventOccurrences,
} from "../_shared/mutation.ts";

Deno.serve(async (req) => {
  const auth = req.headers.get("x-webhook-secret");
  const secret = Deno.env.get("WEBHOOK_SECRET");

  if (!auth || auth !== `Bearer ${secret}`) {
    console.error("Unauthorized: Status 401");
    return new Response("Unauthorized", { status: 401 });
  }

  const event_date_rules: Tables<"event_date_rules"> = await req.json();

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  if (event_date_rules === null) {
    console.error(`Missing event rule`);
    return new Response("Missing Event Rule.");
  }
  const occurrenceDates = await materializeEventOccurrences(
    event_date_rules,
    today,
    4,
  );

  await deleteEventOccurrences(event_date_rules.event_id);

  const occurrences: { event_id: string; occurs_on: string }[] = occurrenceDates
    .map((date) => ({
      event_id: event_date_rules.event_id,
      occurs_on: date,
    }));

  await upsertEventOccurrences(occurrences);

  console.log("Success, Function Complete");

  const data = {
    message: `Function complete!`,
  };

  return new Response(
    JSON.stringify(data),
    { headers: { "Content-Type": "application/json" } },
  );
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/add-occurrences-new-event' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
