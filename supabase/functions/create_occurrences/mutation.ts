import { supabaseAdmin } from "./constants.ts";

export async function addTraditionOccurrences(
  occurrences: { tradition_id: string; occurs_on: string }[],
) {
  try {
    const { data, error } = await supabaseAdmin
      .from("tradition_occurrences")
      .insert(occurrences);

    if (error) {
      throw error;
    }
    return data;
  } catch (err) {
    if (err instanceof Error) {
      console.error(err.message); // TypeScript now knows 'message' exists
      // Handle the error, maybe return a response
      return new Response(JSON.stringify({ error: err.message }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    } else {
      // Handle cases where the thrown value isn't a standard Error object
      console.error("An unknown error occurred");
      return new Response(
        JSON.stringify({ error: "An unknown error occurred" }),
        {
          status: 500,
          headers: { "Content-Type": "application/json" },
        },
      );
    }
  }
}
