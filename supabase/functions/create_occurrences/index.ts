// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "@supabase/functions-js/edge-runtime.d.ts";
// import { easter } from "@date-easter";
import { helperFns, materializeOccurrences } from "./utils.ts";
import { addTraditionOccurrences } from "./mutation.ts";
import { getTraditionSet } from "./query.ts";
// import { getEaster } from "./query.ts";

Deno.serve(async (req) => {
  const { name } = await req.json();
  // const addEaster = easter(2018);

  // const easterId = "fb6fc016-ef39-58ea-90a9-b5fad9f9cf4d";
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const todayIso = today.toISOString().slice(0, 10);

  console.log("Test");

  // const getEaster = await materializeOccurrences(easterId, today, 4);

  // const easterObject = getEaster.map((date) => ({
  //   tradition_id: easterId,
  //   occurs_on: date,
  // }));

  // addTraditionOccurrences(easterObject);
  let lastId = null;

  while (true) {
    const occurrences: { tradition_id: string; occurs_on: string }[] = [];
    const data = await getTraditionSet(100, lastId, todayIso);

    if (data instanceof Response) {
      console.log(data);
      break;
    }

    if (!data.length) break;

    for (const tradition of data) {
      lastId = tradition.id;
      if (tradition.tradition_occurrences.length >= 4) continue;
      if (tradition.tradition_date_rules === null) {
        console.error(`Missing tradition rule for ${tradition.id}`);
        continue;
      }
      const occurrenceDates = await materializeOccurrences(
        tradition.tradition_date_rules,
        today,
        4,
      );
      const existingDates = tradition.tradition_occurrences.map((item) =>
        item.occurs_on ? item.occurs_on : ""
      );
      const newDates = helperFns.processDissimilarStringArrays(
        occurrenceDates,
        existingDates,
      );
      if (newDates.length === 0) continue;
      newDates.forEach((date) =>
        occurrences.push({ tradition_id: tradition.id, occurs_on: date })
      );
    }
    addTraditionOccurrences(occurrences);
  }
  // const traditionSet = await getTraditionSet(100, null, todayIso);
  // console.log(traditionSet);

  const data = {
    message: `Hello ${name} Easter Year:!`,
  };

  return new Response(
    JSON.stringify(data),
    { headers: { "Content-Type": "application/json" } },
  );
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/create_occurrences' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
