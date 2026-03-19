// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "@supabase/functions-js/edge-runtime.d.ts";
import { Tables } from "../../../database.types.ts";
import { materializeOccurrences } from "../_shared/utils.ts";
import {
  deleteTraditionOccurrences,
  upsertTraditionOccurrences,
} from "../_shared/mutation.ts";

console.log("Hello from Functions!");

Deno.serve(async (req) => {
  const auth = req.headers.get("x-webhook-secret");
  const secret = Deno.env.get("WEBHOOK_SECRET");

  if (!auth || auth !== `Bearer ${secret}`) {
    console.error("Unauthorized: Status 401");
    return new Response("Unauthorized", { status: 401 });
  }

  const tradition_date_rules: Tables<"tradition_date_rules"> = await req.json();

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  if (tradition_date_rules === null) {
    console.error(`Missing tradition rule`);
    return new Response("Missing Tradition Rule.");
  }
  const occurrenceDates = await materializeOccurrences(
    tradition_date_rules,
    today,
    4,
  );

  await deleteTraditionOccurrences(tradition_date_rules.tradition_id);

  const occurrences: { tradition_id: string; occurs_on: string }[] =
    occurrenceDates.map((date) => ({
      tradition_id: tradition_date_rules.tradition_id,
      occurs_on: date,
    }));

  await upsertTraditionOccurrences(occurrences);

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

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/add-occurrence-new-tradition' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
