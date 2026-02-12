import { createClient } from "@supabase-js";
import { Database } from "../../../database.types.ts";

export const supabaseAdmin = createClient<Database>(
  Deno.env.get("SUPABASE_URL") ?? "",
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
);
