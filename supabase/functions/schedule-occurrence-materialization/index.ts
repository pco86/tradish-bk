// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "@supabase/functions-js/edge-runtime.d.ts";
import { helperFns, materializeEventOccurrences } from "../_shared/utils.ts";
import {
  addEventOccurrences,
  addTraditionOccurrences,
} from "../_shared/mutation.ts";
import {
  getEventDateRuleSet,
  getTraditionSet,
  resloveTraditionBaseFrequency,
} from "../_shared/query.ts";
import { occursOn } from "../_shared/schemas.ts";

Deno.serve(async () => {
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  let eventLastId = null;

  while (true) {
    const event_occurrences: { event_id: string; occurs_on: string }[] = [];
    const data = await getEventDateRuleSet(100, eventLastId);

    if (data instanceof Response) {
      console.error(data);
      break;
    }

    if (!data.length) break;

    for (const event of data) {
      eventLastId = event.event_id;
      const getOccurences = occursOn.safeParse(event.occurrences);
      if (getOccurences.success && getOccurences.data.length >= 4) continue;
      if (event.id === null) {
        console.error(`Missing event rule for ${event.event_id}`);
        continue;
      }
      if (event.event_id === null) {
        console.error(`Missing event id`);
        continue;
      }

      const occurrenceDates = await materializeEventOccurrences(
        event.frequency,
        event.event_id,
        event.relative_event_id,
        event.rule_type,
        event.config,
        event.event_operations,
        today,
        4,
      );
      const existingDates = getOccurences.success
        ? getOccurences.data.map((item) => item.occurs_on ? item.occurs_on : "")
        : [];
      const newDates = helperFns.processDissimilarStringArrays(
        occurrenceDates,
        existingDates,
      );
      if (newDates.length === 0) continue;
      const eventId = event.event_id;
      newDates.forEach(
        (date) => {
          event_occurrences.push({ event_id: eventId, occurs_on: date });
        },
      );
    }
    await addEventOccurrences(event_occurrences);
  }

  let lastId = null;

  while (true) {
    const occurrences: { tradition_id: string; occurs_on: string }[] = [];
    const data = await getTraditionSet(100, lastId);

    if (data instanceof Response) {
      console.log(data);
      break;
    }

    if (!data.length) break;

    for (const tradition of data) {
      lastId = tradition.tradition_id;
      const getOccurences = occursOn.safeParse(tradition.occurrences);

      if (getOccurences.success && getOccurences.data.length >= 4) continue;
      if (tradition.tradition_id === null) {
        console.error(
          `Missing event id for tradition with id: ${tradition.event_id}`,
        );
        continue;
      }
      const resolvedFrequency = await resloveTraditionBaseFrequency(
        tradition.tradition_id,
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
      const existingDates = getOccurences.success
        ? getOccurences.data.map((item) => item.occurs_on ? item.occurs_on : "")
        : [];
      const newDates = helperFns.processDissimilarStringArrays(
        occurrenceDates,
        existingDates,
      );
      if (newDates.length === 0) continue;
      const traditionId = tradition.tradition_id;

      newDates.forEach(
        (date) => {
          occurrences.push({
            tradition_id: traditionId,
            occurs_on: date,
          });
        },
      );
    }
    await addTraditionOccurrences(occurrences);
  }

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

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/schedule-occurrence-materialization' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
