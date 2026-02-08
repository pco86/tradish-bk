import { easter } from "@date-easter";
import { getTraditionById } from "./query.ts";
import { Tables } from "../../../database.types.ts";

export const resolveFixed = (
  rule: Tables<"tradition_date_rules">,
  fromDate: Date,
) => {
  const year = fromDate.getFullYear();
  if (rule.month === null || rule.day === null) {
    console.error(
      `Create Occurrence Edge Function: Fixed date does not have a month or day.`,
    );
    return null;
  }
  const date = new Date(year, rule.month, rule.day);
  return date;
};

const easterWestern = (year: number) => {
  const easterDate = easter(year);
  const date = new Date(easterDate.year, easterDate.month - 1, easterDate.day);
  return date;
};

type ComputedRuleHandler = (date: Date) => Date;

const computedRuleHandler: Record<string, ComputedRuleHandler> = {
  "easter-western": (date) => {
    const year = date.getFullYear();
    return easterWestern(year);
  },
};

export const resolveComputed = (
  rule: Tables<"tradition_date_rules">,
  date: Date,
) => {
  const handler = computedRuleHandler[rule.algorithm ? rule.algorithm : ""];

  if (!handler) {
    console.error(
      `Create Occurrence Edge Function: Unknown operation: ${name}`,
    );
    return null;
  }

  return handler(date);
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

type OperationHandler = (date: Date, args: string[]) => Date;

const operationHandlers: Record<string, OperationHandler> = {
  "previous-weekday": (date, args) => {
    const targetDay = parseInt(args[0]);
    return previousWeekday(date, targetDay);
  },
  "previous-weekday-strict": (date, args) => {
    const targetDay = parseInt(args[0]);
    return previousWeekdayStrict(date, targetDay);
  },
  "next-weekday": (date, args) => {
    const targetDay = parseInt(args[0]);
    return nextWeekday(date, targetDay);
  },
  "next-weekday-strict": (date, args) => {
    const targetDay = parseInt(args[0]);
    return nextWeekdayStrict(date, targetDay);
  },
  "offset-days": (date, args) => {
    const days = parseInt(args[0]);
    return addDays(date, days);
  },
  "offset-weeks": (date, args) => {
    const weeks = parseInt(args[0]);
    return addDays(date, weeks * 7);
  },
  "nth-weekday-of-month": (date, args) => {
    const [month, weekday, n] = args.map(Number);
    return nthWeekdayOfMonth(date.getFullYear(), month, weekday, n);
  },
};

export const applyOperation = (date: Date, op: string) => {
  const [name, argString] = op.split(":");
  const handler = operationHandlers[name];

  if (!handler) {
    console.error(
      `Create Occurrence Edge Function: Unknown operation: ${name}`,
    );
    return;
  }

  const args = argString ? argString.split(",") : [];
  return handler(date, args);
};

export const resolveRule = async (
  rule: Tables<"tradition_date_rules">,
  fromDate: Date,
  visited: Set<string>,
): Promise<Date | null> => {
  if (visited.has(rule.tradition_id)) {
    console.error(
      `Create Occurrence Edge Function: Circular tradition dependency detected: ${rule.tradition_id}`,
    );
  }

  visited.add(rule.tradition_id);

  let date: Date | null;

  switch (rule.rule_type) {
    case "fixed":
      date = resolveFixed(rule, fromDate);
      break;

    case "computed":
      date = resolveComputed(rule, fromDate);
      break;

    case "relative": {
      if (!rule.relative_tradition_id) {
        console.error(
          `Create Occurrences: Relative rule missing for this tradition's rule: ${rule.tradition_id}`,
        );
        date = null;
        break;
      }
      const relativeRule = await getRuleForTradition(
        rule.relative_tradition_id,
      );
      if (relativeRule === null) return null;
      date = await resolveRule(
        relativeRule,
        fromDate,
        visited,
      );
      break;
    }

    default:
      console.error(`Create Occurrences: Unknown rule_type: ${rule.rule_type}`);
      date = null;
  }

  if (date === null) return null;

  for (const op of rule.operations ?? []) {
    if (date === null) continue;
    const newDate = applyOperation(date, op);
    if (newDate instanceof Date) date = newDate;
  }

  visited.delete(rule.tradition_id);

  return date;
};

function advanceByFrequency(
  date: Date,
  rule: Tables<"tradition_date_rules">,
  count: number,
) {
  const d = new Date(date);

  switch (rule.frequency) {
    case "weekly":
      d.setDate(d.getDate() + 7 * (rule.interval ?? 1) * count);
      break;

    case "monthly":
      d.setMonth(d.getMonth() + (rule.interval ?? 1) * count);
      break;

    case "yearly":
      d.setFullYear(d.getFullYear() + (rule.interval ?? 1) * count);
      break;

    default:
      console.error("Create Occurrences: Unsupported Frequency");
  }

  d.setHours(0, 0, 0, 0);
  return d;
}

export async function materializeOccurrences(
  rule: Tables<"tradition_date_rules">,
  fromDate: Date,
  count: number,
) {
  const occurrences = [];

  for (let i = 0; i < count; i++) {
    const nextDate = advanceByFrequency(fromDate, rule, i);

    const traditionDate = await resolveRule(
      rule,
      nextDate,
      new Set<string>(),
    );
    if (traditionDate === null) continue;
    occurrences.push(traditionDate.toISOString().slice(0, 10));
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
    arr1: string[] | undefined,
    arr2: string[] | undefined,
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
