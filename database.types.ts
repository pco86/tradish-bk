export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  graphql_public: {
    Tables: {
      [_ in never]: never
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      graphql: {
        Args: {
          extensions?: Json
          operationName?: string
          query?: string
          variables?: Json
        }
        Returns: Json
      }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
  public: {
    Tables: {
      event_date_rule_operations: {
        Row: {
          config: Json
          created_at: string
          event_date_rule_id: string
          id: string
          sort_order: number
          type: string
          updated_at: string
        }
        Insert: {
          config: Json
          created_at?: string
          event_date_rule_id: string
          id?: string
          sort_order: number
          type: string
          updated_at?: string
        }
        Update: {
          config?: Json
          created_at?: string
          event_date_rule_id?: string
          id?: string
          sort_order?: number
          type?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "event_date_rule_operations_event_date_rule_id_fkey"
            columns: ["event_date_rule_id"]
            isOneToOne: false
            referencedRelation: "event_date_rule_set"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "event_date_rule_operations_event_date_rule_id_fkey"
            columns: ["event_date_rule_id"]
            isOneToOne: false
            referencedRelation: "event_date_rules"
            referencedColumns: ["id"]
          },
        ]
      }
      event_date_rules: {
        Row: {
          algorithm: string | null
          calendar_type: string | null
          config: Json | null
          created_at: string
          day: number | null
          event_id: string
          frequency: string | null
          id: string
          interval: number | null
          month: number | null
          operations: string[] | null
          relative_event_id: string | null
          rule_type: string | null
          status: string
          updated_at: string
          week_of_month: number | null
          weekday: number | null
        }
        Insert: {
          algorithm?: string | null
          calendar_type?: string | null
          config?: Json | null
          created_at?: string
          day?: number | null
          event_id: string
          frequency?: string | null
          id?: string
          interval?: number | null
          month?: number | null
          operations?: string[] | null
          relative_event_id?: string | null
          rule_type?: string | null
          status?: string
          updated_at?: string
          week_of_month?: number | null
          weekday?: number | null
        }
        Update: {
          algorithm?: string | null
          calendar_type?: string | null
          config?: Json | null
          created_at?: string
          day?: number | null
          event_id?: string
          frequency?: string | null
          id?: string
          interval?: number | null
          month?: number | null
          operations?: string[] | null
          relative_event_id?: string | null
          rule_type?: string | null
          status?: string
          updated_at?: string
          week_of_month?: number | null
          weekday?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "event_date_rules_event_id_fkey"
            columns: ["event_id"]
            isOneToOne: true
            referencedRelation: "events"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "event_date_rules_relative_event_id_fkey"
            columns: ["relative_event_id"]
            isOneToOne: false
            referencedRelation: "events"
            referencedColumns: ["id"]
          },
        ]
      }
      event_occurrences: {
        Row: {
          created_at: string
          event_id: string
          id: string
          occurs_on: string | null
          updated_at: string
        }
        Insert: {
          created_at?: string
          event_id: string
          id?: string
          occurs_on?: string | null
          updated_at?: string
        }
        Update: {
          created_at?: string
          event_id?: string
          id?: string
          occurs_on?: string | null
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "event_occurrences_event_id_fkey"
            columns: ["event_id"]
            isOneToOne: false
            referencedRelation: "events"
            referencedColumns: ["id"]
          },
        ]
      }
      events: {
        Row: {
          created_at: string
          deleted_at: string | null
          id: string
          long_description: string | null
          short_description: string | null
          title: string
          updated_at: string
          user_id: string | null
          visibility: string
        }
        Insert: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          long_description?: string | null
          short_description?: string | null
          title: string
          updated_at?: string
          user_id?: string | null
          visibility?: string
        }
        Update: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          long_description?: string | null
          short_description?: string | null
          title?: string
          updated_at?: string
          user_id?: string | null
          visibility?: string
        }
        Relationships: []
      }
      rule_type_requirements: {
        Row: {
          required_fields: string[] | null
          rule_type: string
        }
        Insert: {
          required_fields?: string[] | null
          rule_type: string
        }
        Update: {
          required_fields?: string[] | null
          rule_type?: string
        }
        Relationships: []
      }
      tradition_date_rule_operations: {
        Row: {
          config: Json
          created_at: string
          id: string
          sort_order: number
          tradition_id: string
          type: string
          updated_at: string
        }
        Insert: {
          config: Json
          created_at?: string
          id?: string
          sort_order: number
          tradition_id: string
          type: string
          updated_at?: string
        }
        Update: {
          config?: Json
          created_at?: string
          id?: string
          sort_order?: number
          tradition_id?: string
          type?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "tradition_date_rule_operations_tradition_id_fkey"
            columns: ["tradition_id"]
            isOneToOne: false
            referencedRelation: "tradition_date_rule_set"
            referencedColumns: ["tradition_id"]
          },
          {
            foreignKeyName: "tradition_date_rule_operations_tradition_id_fkey"
            columns: ["tradition_id"]
            isOneToOne: false
            referencedRelation: "traditions"
            referencedColumns: ["id"]
          },
        ]
      }
      tradition_date_rules: {
        Row: {
          algorithm: string | null
          calendar_type: string | null
          created_at: string
          day: number | null
          frequency: string | null
          id: string
          interval: number | null
          month: number | null
          operations: string[] | null
          relative_event_id: string | null
          relative_tradition_id: string | null
          rule_type: string | null
          tradition_id: string
          updated_at: string
          week_of_month: number | null
          weekday: number | null
        }
        Insert: {
          algorithm?: string | null
          calendar_type?: string | null
          created_at?: string
          day?: number | null
          frequency?: string | null
          id?: string
          interval?: number | null
          month?: number | null
          operations?: string[] | null
          relative_event_id?: string | null
          relative_tradition_id?: string | null
          rule_type?: string | null
          tradition_id: string
          updated_at?: string
          week_of_month?: number | null
          weekday?: number | null
        }
        Update: {
          algorithm?: string | null
          calendar_type?: string | null
          created_at?: string
          day?: number | null
          frequency?: string | null
          id?: string
          interval?: number | null
          month?: number | null
          operations?: string[] | null
          relative_event_id?: string | null
          relative_tradition_id?: string | null
          rule_type?: string | null
          tradition_id?: string
          updated_at?: string
          week_of_month?: number | null
          weekday?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "tradition_date_rules_relative_event_id_fkey"
            columns: ["relative_event_id"]
            isOneToOne: false
            referencedRelation: "events"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tradition_date_rules_relative_tradition_id_fkey"
            columns: ["relative_tradition_id"]
            isOneToOne: false
            referencedRelation: "tradition_date_rule_set"
            referencedColumns: ["tradition_id"]
          },
          {
            foreignKeyName: "tradition_date_rules_relative_tradition_id_fkey"
            columns: ["relative_tradition_id"]
            isOneToOne: false
            referencedRelation: "traditions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tradition_date_rules_tradition_id_fkey"
            columns: ["tradition_id"]
            isOneToOne: true
            referencedRelation: "tradition_date_rule_set"
            referencedColumns: ["tradition_id"]
          },
          {
            foreignKeyName: "tradition_date_rules_tradition_id_fkey"
            columns: ["tradition_id"]
            isOneToOne: true
            referencedRelation: "traditions"
            referencedColumns: ["id"]
          },
        ]
      }
      tradition_occurrences: {
        Row: {
          created_at: string
          id: string
          occurs_on: string | null
          tradition_id: string
          updated_at: string
        }
        Insert: {
          created_at?: string
          id?: string
          occurs_on?: string | null
          tradition_id: string
          updated_at?: string
        }
        Update: {
          created_at?: string
          id?: string
          occurs_on?: string | null
          tradition_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "tradition_occurrences_tradition_id_fkey"
            columns: ["tradition_id"]
            isOneToOne: false
            referencedRelation: "tradition_date_rule_set"
            referencedColumns: ["tradition_id"]
          },
          {
            foreignKeyName: "tradition_occurrences_tradition_id_fkey"
            columns: ["tradition_id"]
            isOneToOne: false
            referencedRelation: "traditions"
            referencedColumns: ["id"]
          },
        ]
      }
      tradition_prep_steps: {
        Row: {
          created_at: string
          description: string
          id: string
          parent_step_id: string | null
          sort_order: number
          step_type: string
          tradition_id: string
          user_id: string | null
        }
        Insert: {
          created_at?: string
          description: string
          id?: string
          parent_step_id?: string | null
          sort_order: number
          step_type?: string
          tradition_id: string
          user_id?: string | null
        }
        Update: {
          created_at?: string
          description?: string
          id?: string
          parent_step_id?: string | null
          sort_order?: number
          step_type?: string
          tradition_id?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "tradition_prep_steps_parent_step_id_fkey"
            columns: ["parent_step_id"]
            isOneToOne: false
            referencedRelation: "tradition_prep_steps"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "tradition_prep_steps_tradition_id_fkey"
            columns: ["tradition_id"]
            isOneToOne: false
            referencedRelation: "tradition_date_rule_set"
            referencedColumns: ["tradition_id"]
          },
          {
            foreignKeyName: "tradition_prep_steps_tradition_id_fkey"
            columns: ["tradition_id"]
            isOneToOne: false
            referencedRelation: "traditions"
            referencedColumns: ["id"]
          },
        ]
      }
      traditions: {
        Row: {
          created_at: string
          deleted_at: string | null
          event_id: string | null
          id: string
          is_default: boolean
          long_description: string | null
          notes: string | null
          operations: Json
          short_description: string | null
          title: string
          updated_at: string
          user_id: string | null
          visibility: string
        }
        Insert: {
          created_at?: string
          deleted_at?: string | null
          event_id?: string | null
          id?: string
          is_default?: boolean
          long_description?: string | null
          notes?: string | null
          operations: Json
          short_description?: string | null
          title: string
          updated_at?: string
          user_id?: string | null
          visibility?: string
        }
        Update: {
          created_at?: string
          deleted_at?: string | null
          event_id?: string | null
          id?: string
          is_default?: boolean
          long_description?: string | null
          notes?: string | null
          operations?: Json
          short_description?: string | null
          title?: string
          updated_at?: string
          user_id?: string | null
          visibility?: string
        }
        Relationships: [
          {
            foreignKeyName: "traditions_event_id_fkey"
            columns: ["event_id"]
            isOneToOne: false
            referencedRelation: "events"
            referencedColumns: ["id"]
          },
        ]
      }
      user_events: {
        Row: {
          created_at: string | null
          event_id: string | null
          id: string
          notification_time: string | null
          reminders_enabled: boolean
          user_id: string
        }
        Insert: {
          created_at?: string | null
          event_id?: string | null
          id?: string
          notification_time?: string | null
          reminders_enabled?: boolean
          user_id?: string
        }
        Update: {
          created_at?: string | null
          event_id?: string | null
          id?: string
          notification_time?: string | null
          reminders_enabled?: boolean
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_events_event_id_fkey"
            columns: ["event_id"]
            isOneToOne: false
            referencedRelation: "events"
            referencedColumns: ["id"]
          },
        ]
      }
      user_steps_complete: {
        Row: {
          created_at: string
          id: string
          is_complete: boolean
          occurrence_id: string
          step_id: string
          updated_at: string
          user_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          is_complete?: boolean
          occurrence_id: string
          step_id: string
          updated_at?: string
          user_id?: string
        }
        Update: {
          created_at?: string
          id?: string
          is_complete?: boolean
          occurrence_id?: string
          step_id?: string
          updated_at?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_steps_complete_occurrence_id_fkey"
            columns: ["occurrence_id"]
            isOneToOne: false
            referencedRelation: "tradition_occurrences"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_steps_complete_step_id_fkey"
            columns: ["step_id"]
            isOneToOne: false
            referencedRelation: "tradition_prep_steps"
            referencedColumns: ["id"]
          },
        ]
      }
      user_traditions: {
        Row: {
          created_at: string | null
          id: string
          notification_time: string | null
          reminders_enabled: boolean
          tradition_id: string | null
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          notification_time?: string | null
          reminders_enabled?: boolean
          tradition_id?: string | null
          user_id?: string
        }
        Update: {
          created_at?: string | null
          id?: string
          notification_time?: string | null
          reminders_enabled?: boolean
          tradition_id?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_traditions_tradition_id_fkey"
            columns: ["tradition_id"]
            isOneToOne: false
            referencedRelation: "tradition_date_rule_set"
            referencedColumns: ["tradition_id"]
          },
          {
            foreignKeyName: "user_traditions_tradition_id_fkey"
            columns: ["tradition_id"]
            isOneToOne: false
            referencedRelation: "traditions"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      event_date_rule_set: {
        Row: {
          algorithm: string | null
          calendar_type: string | null
          config: Json | null
          created_at: string | null
          day: number | null
          event_id: string | null
          event_operations: Json | null
          event_title: string | null
          frequency: string | null
          id: string | null
          interval: number | null
          month: number | null
          occurrences: Json | null
          operations: string[] | null
          relative_event_id: string | null
          rule_type: string | null
          updated_at: string | null
          week_of_month: number | null
          weekday: number | null
        }
        Relationships: [
          {
            foreignKeyName: "event_date_rules_event_id_fkey"
            columns: ["event_id"]
            isOneToOne: true
            referencedRelation: "events"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "event_date_rules_relative_event_id_fkey"
            columns: ["relative_event_id"]
            isOneToOne: false
            referencedRelation: "events"
            referencedColumns: ["id"]
          },
        ]
      }
      tradition_date_rule_set: {
        Row: {
          event_id: string | null
          frequency: string | null
          occurrences: Json | null
          tradition_id: string | null
          tradition_operations: Json | null
          tradition_title: string | null
        }
        Relationships: [
          {
            foreignKeyName: "traditions_event_id_fkey"
            columns: ["event_id"]
            isOneToOne: false
            referencedRelation: "events"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Functions: {
      determine_rule_status: {
        Args: {
          new_rule: Database["public"]["Tables"]["event_date_rules"]["Row"]
        }
        Returns: string
      }
      resolve_base_frequency: { Args: { p_event_id: string }; Returns: string }
      resolve_tradition_base_frequency: {
        Args: { p_tradition_id: string }
        Returns: string
      }
      schedule_occurrence_generation: { Args: never; Returns: undefined }
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  graphql_public: {
    Enums: {},
  },
  public: {
    Enums: {},
  },
} as const

