// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "@supabase/functions-js/edge-runtime.d.ts";
import { Tables } from "../../../database.types.ts";
import { materializeEventOccurrences } from "../_shared/utils.ts";
import {
  deleteTraditionOccurrences,
  upsertTraditionOccurrences,
} from "../_shared/mutation.ts";
import {
  getTraditionRuleSetById,
  resloveTraditionBaseFrequency,
} from "../_shared/query.ts";

Deno.serve(async (req) => {
  const auth = req.headers.get("x-webhook-secret");
  const secret = Deno.env.get("WEBHOOK_SECRET");

  if (!auth || auth !== `Bearer ${secret}`) {
    console.error("Unauthorized: Status 401");
    return new Response("Unauthorized", { status: 401 });
  }

  const newTradition: Tables<"traditions"> = await req.json();

  const tradition = await getTraditionRuleSetById(newTradition.id);

  if (tradition instanceof Response) {
    console.error(tradition);
    return new Response(
      JSON.stringify(tradition),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  const today = new Date();
  today.setHours(0, 0, 0, 0);

  if (tradition === null || tradition.event_id === null) {
    console.error(`Missing tradition rule or event id on ${newTradition.id}`);
    return new Response("Missing Tradition Rule.");
  }

  const resolvedFrequency = await resloveTraditionBaseFrequency(
    newTradition.id,
  );

  if (resolvedFrequency instanceof Response || resolvedFrequency === null) {
    console.error(
      `Create Occurrence Edge Function: Get Tradition By ID response error.`,
    );
    return new Response(
      JSON.stringify(resolvedFrequency),
      { headers: { "Content-Type": "application/json" } },
    );
  }

  const occurrenceDates = await materializeEventOccurrences(
    resolvedFrequency,
    tradition.tradition_id,
    tradition.event_id,
    "relative",
    null,
    tradition.tradition_operations,
    today,
    4,
  );

  if (occurrenceDates === undefined) {
    console.error("Occurrence Dates were not properly generated");
    return new Response("Occurrence Dates were not properly generated");
  }

  if (occurrenceDates === null) {
    console.error(`Unable to generate occurrence dates for ${newTradition.id}`);
    return new Response(
      `Unable to generate occurrence dates for ${newTradition.id}`,
    );
  }

  await deleteTraditionOccurrences(newTradition.id);

  const occurrences: { tradition_id: string; occurs_on: string }[] =
    occurrenceDates.map((date) => ({
      tradition_id: newTradition.id,
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
