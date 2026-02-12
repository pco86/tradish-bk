import { createClient } from "@supabase-js";
import { Database } from "../../../database.types.ts";

export const supabaseClient = createClient<Database>(
  Deno.env.get("SUPABASE_URL") ?? "",
  Deno.env.get("SUPABASE_ANON_KEY") ?? "",
);
