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
          relative_tradition_id?: string | null
          rule_type?: string | null
          tradition_id?: string
          updated_at?: string
          week_of_month?: number | null
          weekday?: number | null
        }
        Relationships: [
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
          sort_order: number
          tradition_id: string
        }
        Insert: {
          created_at?: string
          description: string
          id?: string
          sort_order: number
          tradition_id: string
        }
        Update: {
          created_at?: string
          description?: string
          id?: string
          sort_order?: number
          tradition_id?: string
        }
        Relationships: [
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
          id: string
          long_description: string | null
          notes: string | null
          short_description: string | null
          title: string
          updated_at: string
          user_id: string | null
          version: number | null
          visibility: string
        }
        Insert: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          long_description?: string | null
          notes?: string | null
          short_description?: string | null
          title: string
          updated_at?: string
          user_id?: string | null
          version?: number | null
          visibility?: string
        }
        Update: {
          created_at?: string
          deleted_at?: string | null
          id?: string
          long_description?: string | null
          notes?: string | null
          short_description?: string | null
          title?: string
          updated_at?: string
          user_id?: string | null
          version?: number | null
          visibility?: string
        }
        Relationships: []
      }
      user_steps_complete: {
        Row: {
          completed_at: string | null
          created_at: string
          id: string
          is_completed: boolean
          occurrence_id: string
          updated_at: string
          user_step_id: string
        }
        Insert: {
          completed_at?: string | null
          created_at?: string
          id?: string
          is_completed?: boolean
          occurrence_id: string
          updated_at?: string
          user_step_id: string
        }
        Update: {
          completed_at?: string | null
          created_at?: string
          id?: string
          is_completed?: boolean
          occurrence_id?: string
          updated_at?: string
          user_step_id?: string
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
            foreignKeyName: "user_steps_complete_user_step_id_fkey"
            columns: ["user_step_id"]
            isOneToOne: false
            referencedRelation: "user_tradition_prep_steps"
            referencedColumns: ["id"]
          },
        ]
      }
      user_tradition_prep_steps: {
        Row: {
          created_at: string
          custom_description: string | null
          id: string
          is_removed: boolean
          sort_order: number
          tradition_prep_step_id: string | null
          user_tradition_id: string
        }
        Insert: {
          created_at?: string
          custom_description?: string | null
          id?: string
          is_removed?: boolean
          sort_order: number
          tradition_prep_step_id?: string | null
          user_tradition_id: string
        }
        Update: {
          created_at?: string
          custom_description?: string | null
          id?: string
          is_removed?: boolean
          sort_order?: number
          tradition_prep_step_id?: string | null
          user_tradition_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_tradition_prep_steps_tradition_prep_step_id_fkey"
            columns: ["tradition_prep_step_id"]
            isOneToOne: false
            referencedRelation: "tradition_prep_steps"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_tradition_prep_steps_user_tradition_id_fkey"
            columns: ["user_tradition_id"]
            isOneToOne: false
            referencedRelation: "user_traditions"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "user_tradition_prep_steps_user_tradition_id_fkey1"
            columns: ["user_tradition_id"]
            isOneToOne: false
            referencedRelation: "user_traditions"
            referencedColumns: ["id"]
          },
        ]
      }
      user_traditions: {
        Row: {
          created_at: string | null
          id: string
          notification_time: string | null
          parent_tradition_id: string | null
          reminders_enabled: boolean
          tradition_id: string | null
          user_id: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          notification_time?: string | null
          parent_tradition_id?: string | null
          reminders_enabled?: boolean
          tradition_id?: string | null
          user_id?: string
        }
        Update: {
          created_at?: string | null
          id?: string
          notification_time?: string | null
          parent_tradition_id?: string | null
          reminders_enabled?: boolean
          tradition_id?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "user_traditions_parent_tradition_id_fkey"
            columns: ["parent_tradition_id"]
            isOneToOne: false
            referencedRelation: "traditions"
            referencedColumns: ["id"]
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
      [_ in never]: never
    }
    Functions: {
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

