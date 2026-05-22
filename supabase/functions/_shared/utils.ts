import { easter } from "@date-easter";
import {
  getEventRuleById,
  getTraditionById,
  resloveBaseFrequency,
  resloveTraditionBaseFrequency,
} from "./query.ts";
import {
  AlgorithmTypes,
  DateRuleSchema,
  EventOperationsArraySchema,
  EventOperationsType,
} from "./schemas.ts";

function assertNever(x: never): never {
  throw new Error(`Unexpected object: ${x}`);
}

export const resolveFixed = (
  config: { month: number; day: number },
  fromDate: Date,
) => {
  const year = fromDate.getFullYear();
  const date = new Date(year, config.month, config.day);
  return date;
};

export const resolveWeekly = (
  config: { weekday: number },
  fromDate: Date,
) => {
  const resultDate = new Date(fromDate.getTime());
  const currentWeekday = fromDate.getDay();

  const daysRemaining = config.weekday - currentWeekday;

  if (daysRemaining <= 0) {
    resultDate.setDate(resultDate.getDate() + daysRemaining + 7);
    return resultDate;
  }
  resultDate.setDate(resultDate.getDate() + daysRemaining);
  return resultDate;
};

const easterWestern = (year: number) => {
  const easterDate = easter(year);
  const date = new Date(easterDate.year, easterDate.month - 1, easterDate.day);
  return date;
};

export const resolveComputed = (
  config: AlgorithmTypes,
  date: Date,
) => {
  switch (config.algorithm) {
    case "easter-western":
      return easterWestern(date.getFullYear());
    case "temp-union-param":
      return date;
    default:
      // If a new type is added to the schema but not handled here,
      // TypeScript will flag a compile error on this line.
      return assertNever(config);
  }
};

export const getRuleForTradition = async (traditionId: string) => {
  const rule = await getTraditionById(traditionId);

  if (rule instanceof Response || rule.tradition_date_rules === null) {
    console.error(
      `Create Occurrence Edge Function: Get Tradition By ID response error.`,
    );
    return null;
  }

  return rule.tradition_date_rules;
};

export const getEventRuleForTradition = async (eventId: string) => {
  const rule = await getEventRuleById(eventId);

  if (rule instanceof Response || rule === null) {
    console.error(
      `Create Occurrence Edge Function: Get Tradition By ID response error.`,
    );
    return null;
  }

  return rule;
};

export const checkRelativeFrequency = async (
  eventId: string,
  frequency: string | null,
) => {
  if (frequency != null) return frequency;

  const baseFrequency = await resloveBaseFrequency(eventId);

  if (baseFrequency instanceof Response || baseFrequency === null) {
    console.error(
      `Create Occurrence Edge Function: Get Tradition By ID response error.`,
    );
    return null;
  }

  return baseFrequency;
};

export const getRuleForEvent = async (eventId: string) => {
  const rule = await getEventRuleById(eventId);

  if (rule instanceof Response || rule === null) {
    console.error(
      `Create Occurrence Edge Function: Get Tradition By ID response error.`,
    );
    return null;
  }

  return rule;
};

const addDays = (date: Date, days: number) => {
  const d = new Date(date);
  d.setHours(0, 0, 0, 0);
  d.setDate(d.getDate() + days);
  return d;
};

const previousWeekday = (date: Date, targetDay: number) => {
  const d = new Date(date);
  d.setHours(0, 0, 0, 0);

  const currentDay = d.getDay();
  const daysToSubtract = (currentDay - targetDay + 7) % 7;

  d.setDate(d.getDate() - daysToSubtract);
  return d;
};

const previousWeekdayStrict = (date: Date, targetDay: number) => {
  const d = new Date(date);
  d.setHours(0, 0, 0, 0);

  const currentDay = d.getDay();
  const daysToSubtract = (currentDay - targetDay + 7) % 7;
  const total = daysToSubtract === 0 ? 7 : daysToSubtract;

  d.setDate(d.getDate() - total);
  return d;
};

const nextWeekday = (date: Date, targetDay: number) => {
  const d = new Date(date);
  d.setHours(0, 0, 0, 0);

  const currentDay = d.getDay();
  const daysToAdd = (targetDay - currentDay + 7) % 7;

  d.setDate(d.getDate() + daysToAdd);
  return d;
};

const nextWeekdayStrict = (date: Date, targetDay: number) => {
  const d = new Date(date);
  d.setHours(0, 0, 0, 0);

  const currentDay = d.getDay();
  const daysToAdd = (targetDay - currentDay + 7) % 7;
  const total = daysToAdd === 0 ? 7 : daysToAdd;

  d.setDate(d.getDate() + total);
  return d;
};

const nthWeekdayOfMonth = (
  year: number,
  month: number, // 1-12
  weekday: number, // 0-6 (Sunday = 0)
  n: number, // 1-5 or -1
): Date => {
  if (n === 0 || n < -1 || n > 5) {
    console.error("Invalid n for nth-weekday-of-month");
  }

  // Normalize to first day of month
  const firstOfMonth = new Date(year, month - 1, 1);
  firstOfMonth.setHours(0, 0, 0, 0);

  if (n === -1) {
    // Last weekday of month
    const lastOfMonth = new Date(year, month, 0); // day 0 of next month = last of this month
    lastOfMonth.setHours(0, 0, 0, 0);

    const diff = (lastOfMonth.getDay() - weekday + 7) % 7;
    lastOfMonth.setDate(lastOfMonth.getDate() - diff);
    return lastOfMonth;
  }

  // Find first occurrence of weekday in month
  const firstWeekdayOffset = (weekday - firstOfMonth.getDay() + 7) % 7;

  const day = 1 + firstWeekdayOffset + (n - 1) * 7;

  const result = new Date(year, month - 1, day);
  result.setHours(0, 0, 0, 0);

  return result;
};

function operationHandler(date: Date, operation: EventOperationsType) {
  switch (operation.type) {
    case "previous-weekday":
      return previousWeekday(date, operation.config.weekday);
    case "next-weekday":
      return nextWeekday(date, operation.config.weekday);
    case "previous-weekday-strict":
      return previousWeekdayStrict(date, operation.config.weekday);
    case "next-weekday-strict":
      return nextWeekdayStrict(date, operation.config.weekday);
    case "offset-days":
      return addDays(date, operation.config.amount);
    case "offset-weeks":
      return addDays(date, operation.config.amount * 7);
    case "nth-weekday-of-month":
      return nthWeekdayOfMonth(
        date.getFullYear(),
        operation.config.month,
        operation.config.weekday,
        operation.config.occurrence,
      );
    default:
      // If a new type is added to the schema but not handled here,
      // TypeScript will flag a compile error on this line.
      return assertNever(operation);
  }
}

export const resolveEventRule = async (
  event_id: string | null,
  relative_event_id: string | null,
  rule_type: string | null,
  rawRuleConfig: unknown,
  rawOperations: unknown,
  fromDate: Date,
  visited: Set<string>,
): Promise<Date | null> => {
  if (event_id === null) {
    console.error("Event id is null.");
    return null;
  }
  if (visited.has(event_id)) {
    console.error(
      `Create Occurrence Edge Function: Circular event dependency detected: ${event_id}`,
    );
  }
  const result = DateRuleSchema.safeParse({
    type: rule_type,
    config: rawRuleConfig,
  });

  if (!result.success) {
    console.error("Rule configuration validation failed");
    return null;
  }

  const dateRule = result.data;

  visited.add(event_id);

  let date: Date | null;

  switch (dateRule.type) {
    case "fixed":
      date = resolveFixed(dateRule.config, fromDate);
      break;

    case "computed":
      date = resolveComputed(dateRule.config, fromDate);
      break;

    case "weekly":
      date = resolveWeekly(dateRule.config, fromDate);
      break;

    case "relative": {
      if (!relative_event_id) {
        console.error(
          `Create Occurrences: Relative rule missing for this event's rule: ${event_id}`,
        );
        date = null;
        break;
      }
      const relativeRule = await getRuleForEvent(
        relative_event_id,
      );
      if (relativeRule === null) return null;
      date = await resolveEventRule(
        relativeRule.event_id,
        relativeRule.relative_event_id,
        relativeRule.rule_type,
        relativeRule.config,
        relativeRule.event_operations,
        fromDate,
        visited,
      );
      break;
    }
    default:
      // If a new type is added to the schema but not handled here,
      // TypeScript will flag a compile error on this line.
      return assertNever(dateRule);
  }

  if (date === null) return null;

  const validateOperations = EventOperationsArraySchema.safeParse(
    rawOperations,
  );

  if (validateOperations.success) {
    const operations = validateOperations.data.toSorted((a, b) =>
      a.sort_order - b.sort_order
    );
    for (const op of operations) {
      if (date === null) continue;
      const newDate = operationHandler(date, op);
      if (newDate instanceof Date) date = newDate;
    }
  }

  visited.delete(event_id);

  return date;
};

function advanceByFrequency(
  date: Date,
  frequency: string,
  count: number,
) {
  const d = new Date(date);

  switch (frequency) {
    case "weekly":
      d.setDate(d.getDate() + 7 * count);
      break;

    case "monthly":
      d.setMonth(d.getMonth() + count);
      break;

    case "yearly":
      d.setFullYear(d.getFullYear() + count);
      break;

    default:
      console.error("Create Occurrences: Unsupported Frequency");
  }

  d.setHours(0, 0, 0, 0);
  return d;
}

export async function materializeEventOccurrences(
  frequency: string | null,
  event_id: string | null,
  relative_event_id: string | null,
  rule_type: string | null,
  ruleConfig: unknown,
  rawOperations: unknown,
  fromDate: Date,
  count: number,
) {
  const occurrences: string[] = [];

  if (event_id === null) {
    console.error("Event id is null.");
    return null;
  }

  const resolvedFrequency = await checkRelativeFrequency(event_id, frequency);

  if (resolvedFrequency === null) {
    console.error("Could not resolve frequency for ", event_id);
    return null;
  }

  for (let i = 0; i < count; i++) {
    const nextDate = advanceByFrequency(
      fromDate,
      resolvedFrequency,
      i,
    );

    const eventDate = await resolveEventRule(
      event_id,
      relative_event_id,
      rule_type,
      ruleConfig,
      rawOperations,
      nextDate,
      new Set<string>(),
    );
    if (eventDate === null) continue;
    occurrences.push(eventDate.toISOString().slice(0, 10));
  }

  return occurrences;
}

export const helperFns = {
  /**
   * Takes two arrays. Move common elements. Appends uncommon elements.
   * Returns the modified array. The order the arrays are provided
   * affects the order the items are added i.e. [arr1, arr2].
   *
   * @param arr1
   * @param arr2
   * @returns
   */
  processDissimilarStringArrays(
    arr1: string[] | undefined | null,
    arr2: string[] | undefined | null,
  ) {
    // Ensure inputs are arrays or default to empty arrays
    arr1 = Array.isArray(arr1) ? arr1 : [];
    arr2 = Array.isArray(arr2) ? arr2 : [];

    // Collect dissimilar values
    const dissimilar = [
      ...arr1.filter((value) => !arr2.includes(value)),
      ...arr2.filter((value) => !arr1.includes(value)),
    ];

    return dissimilar;
  },
};
