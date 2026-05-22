import { z } from "@zod";

export const AlgorithmSchema = z.discriminatedUnion("algorithm", [
  z.object({ algorithm: z.literal("easter-western") }),
  z.object({ algorithm: z.literal("temp-union-param") }),
]);

export const DateRuleSchema = z.discriminatedUnion("type", [
  z.object({
    type: z.literal("fixed"),
    config: z.object({ month: z.number(), day: z.number() }),
  }),
  z.object({
    type: z.literal("relative"),
    config: z.null(),
  }),
  z.object({
    type: z.literal("computed"),
    config: AlgorithmSchema,
  }),
  z.object({
    type: z.literal("weekly"),
    config: z.object({ weekday: z.number() }),
  }),
]);

export type DateRuleConfigType = z.infer<typeof DateRuleSchema>;
export type AlgorithmTypes = z.infer<typeof AlgorithmSchema>;

export const occursOn = z.array(
  z.object({
    occurs_on: z.string().nullable(),
  }),
);

export const EventOperationsSchema = z.discriminatedUnion("type", [
  z.object({
    type: z.literal("previous-weekday"),
    config: z.object({ weekday: z.number() }),
    sort_order: z.number(),
  }),
  z.object({
    type: z.literal("next-weekday"),
    config: z.object({ weekday: z.number() }),
    sort_order: z.number(),
  }),
  z.object({
    type: z.literal("previous-weekday-strict"),
    config: z.object({ weekday: z.number() }),
    sort_order: z.number(),
  }),
  z.object({
    type: z.literal("next-weekday-strict"),
    config: z.object({ weekday: z.number() }),
    sort_order: z.number(),
  }),
  z.object({
    type: z.literal("offset-days"),
    config: z.object({ amount: z.number() }),
    sort_order: z.number(),
  }),
  z.object({
    type: z.literal("offset-weeks"),
    config: z.object({ amount: z.number() }),
    sort_order: z.number(),
  }),
  z.object({
    type: z.literal("nth-weekday-of-month"),
    config: z.object({
      month: z.number(),
      weekday: z.number(),
      occurrence: z.number(),
    }),
    sort_order: z.number(),
  }),
]);

export const EventOperationsArraySchema = z.array(EventOperationsSchema);

export type EventOperationsType = z.infer<typeof EventOperationsSchema>;
