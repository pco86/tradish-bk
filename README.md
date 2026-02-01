# Tradish

## Supabase

npx supabase db diff -f desc
npx supabase migration up
npx supabase db reset
npx supabase functions serve name

## Snaplets

npx @snaplet/seed sync
npx tsx seed.ts > supabase/seed.sql

## Operations

| Operation                      | Meaning                 |
| ------------------------------ | ----------------------- |
| `previous-weekday:0`           | Nearest previous Sunday |
| `next-weekday:1`               | Nearest next Monday     |
| `strict-previous-weekday:0`    | Nearest previous Sunday |
| `strict-next-weekday:1`        | Nearest next Monday     |
| `offset-days:-7`               | Subtract 7 days         |
| `offset-weeks:-3`              | Subtract 3 weeks        |
| `nth-weekday-of-month:12,0,-1` | Last Sunday of December |

| Operation                   | Meaning                                     |
| --------------------------- | ------------------------------------------- |
| `previous-weekday:N`        | Nearest weekday N **on or before** the date |
| `next-weekday:N`            | Nearest weekday N **on or after** the date  |
| `strict-previous-weekday:N` | Nearest weekday N **before** the date       |
| `strict-next-weekday:N`     | Nearest weekday N **after** the date        |
