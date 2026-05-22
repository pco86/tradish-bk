import { supabaseClient } from "./supabaseClient.ts";

export async function getTradition() {
  try {
    const { data, error } = await supabaseClient.from("traditions").select("*");

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

export async function getTraditionById(id: string) {
  try {
    const { data, error } = await supabaseClient.from("traditions").select(
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

export async function getEventRuleById(id: string) {
  try {
    const { data, error } = await supabaseClient.from("event_date_rule_set")
      .select().eq("event_id", id).limit(1).single();

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

export async function getEaster() {
  try {
    const { data, error } = await supabaseClient.from("traditions").select(
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

export async function getTraditionSet(
  limit: number,
  lastId: null | string,
) {
  try {
    const query = supabaseClient
      .from("tradition_date_rule_set")
      .select("*")
      .order("tradition_id", { ascending: true })
      .limit(limit);

    if (lastId) {
      query.gt("tradition_id", lastId);
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

export async function getTraditionRuleSetById(
  tradition_id: string,
) {
  try {
    const query = supabaseClient
      .from("tradition_date_rule_set")
      .select("*")
      .eq("tradition_id", tradition_id)
      .single();

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

export async function getEventSet(
  limit: number,
  lastId: null | string,
  today: string,
) {
  try {
    const query = supabaseClient
      .from("events")
      .select(
        `id,
        title, 
        event_date_rules!event_date_rules_event_id_fkey (*), 
        event_occurrences(occurs_on)`,
      )
      .order("id", { ascending: true })
      .limit(limit)
      .gt("event_occurrences.occurs_on", today);

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

export async function getEventDateRuleSet(
  limit: number,
  lastId: null | string,
) {
  try {
    const query = supabaseClient
      .from("event_date_rule_set")
      .select("*")
      .order("event_id", { ascending: true })
      .limit(limit);

    if (lastId) {
      query.gt("event_id", lastId);
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

export async function getEventDateRuleSetById(
  event_id: string,
) {
  try {
    const query = supabaseClient
      .from("event_date_rule_set")
      .select("*")
      .eq("event_id", event_id)
      .single();

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

export async function getEventOccurrencesById(id: string) {
  try {
    const { data, error } = await supabaseClient.from("event_occurrences")
      .select("*")
      .eq("event_id", id);

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

export async function resloveBaseFrequency(event_id: string) {
  try {
    const { data, error } = await supabaseClient.rpc("resolve_base_frequency", {
      p_event_id: event_id,
    });

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

export async function resloveTraditionBaseFrequency(tradition_id: string) {
  try {
    const { data, error } = await supabaseClient.rpc(
      "resolve_tradition_base_frequency",
      {
        p_tradition_id: tradition_id,
      },
    );

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
