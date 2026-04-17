import { supabaseAdmin } from "./supabaseAdmin.ts";

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
      console.error("An unknown error occurred", err);
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

export async function addEventOccurrences(
  occurrences: { event_id: string; occurs_on: string }[],
) {
  try {
    const { data, error } = await supabaseAdmin
      .from("event_occurrences")
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
      console.error("An unknown error occurred add event occurrences", err);
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

export async function upsertTraditionOccurrences(
  occurrences: { tradition_id: string; occurs_on: string }[],
) {
  try {
    const { data, error } = await supabaseAdmin
      .from("tradition_occurrences")
      .upsert(occurrences, { onConflict: "tradition_id, occurs_on" });

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
      console.error("An unknown error occurred", err);
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

export async function upsertEventOccurrences(
  occurrences: { event_id: string; occurs_on: string }[],
) {
  try {
    const { data, error } = await supabaseAdmin
      .from("event_occurrences")
      .upsert(occurrences, { onConflict: "event_id, occurs_on" });

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
      console.error("An unknown error occurred", err);
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

export async function deleteTraditionOccurrences(
  tradition_id: string,
) {
  try {
    const { data, error } = await supabaseAdmin
      .from("tradition_occurrences")
      .delete()
      .eq("tradition_id", tradition_id);

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
      console.error("An unknown error occurred", err);
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

export async function deleteEventOccurrences(
  event_id: string,
) {
  try {
    const { data, error } = await supabaseAdmin
      .from("event_occurrences")
      .delete()
      .eq("event_id", event_id);

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
      console.error("An unknown error occurred", err);
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
