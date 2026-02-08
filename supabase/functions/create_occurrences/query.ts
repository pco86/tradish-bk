import { supabase } from "./constants.ts";

export async function getTradition() {
  try {
    const { data, error } = await supabase.from("traditions").select("*");

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

export async function getTraditionById(id: string) {
  try {
    const { data, error } = await supabase.from("traditions").select(
      `title, tradition_date_rules!tradition_date_rules_tradition_id_fkey (*)`,
    ).eq("id", id).limit(1).single();

    if (error) {
      throw error;
    }

    return data;
    // return new Response(JSON.stringify({ data }), {
    //   headers: { "Content-Type": "application/json" },
    //   status: 200,
    // });
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

export async function getEaster() {
  try {
    const { data, error } = await supabase.from("traditions").select(
      `title, tradition_date_rules!tradition_date_rules_tradition_id_fkey (*)`,
    ).eq("title", "Easter");

    if (error) {
      throw error;
    }

    return data;
    // return new Response(JSON.stringify({ data }), {
    //   headers: { "Content-Type": "application/json" },
    //   status: 200,
    // });
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

export async function getTraditionSet(
  limit: number,
  lastId: null | string,
  today: string,
) {
  try {
    const query = supabase
      .from("traditions")
      .select(
        `id,
        title, 
        tradition_date_rules!tradition_date_rules_tradition_id_fkey (*), 
        tradition_occurrences(occurs_on)`,
      )
      .order("id", { ascending: true })
      .limit(limit)
      .gt("tradition_occurrences.occurs_on", today);

    if (lastId) {
      query.gt("id", lastId);
    }
    const { data, error } = await query;
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
