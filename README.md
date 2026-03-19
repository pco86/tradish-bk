# Tradish

## Supabase

npx supabase migration up
npx supabase migration squash
npx supabase migration new <description_of_migration>

npx supabase db diff -f desc
npx supabase db reset
npx supabase db lint

npx supabase functions new hello-world
npx supabase functions serve name

npx supabase gen types typescript --local > database.types.ts

## Snaplets

npx @snaplet/seed sync
npx tsx seed.ts > supabase/seed.sql

## Operations

| Operation                      | Meaning                 |
| ------------------------------ | ----------------------- |
| `previous-weekday:0`           | Nearest previous Sunday |
| `next-weekday:1`               | Nearest next Monday     |
| `previous-weekday-strict:0`    | Nearest previous Sunday |
| `next-weekday-strict:1`        | Nearest next Monday     |
| `offset-days:-7`               | Subtract 7 days         |
| `offset-weeks:-3`              | Subtract 3 weeks        |
| `nth-weekday-of-month:12,0,-1` | Last Sunday of December |

| Operation                   | Meaning                                     |
| --------------------------- | ------------------------------------------- |
| `previous-weekday:N`        | Nearest weekday N **on or before** the date |
| `next-weekday:N`            | Nearest weekday N **on or after** the date  |
| `previous-weekday-strict:N` | Nearest weekday N **before** the date       |
| `next-weekday-strict:N`     | Nearest weekday N **after** the date        |

## Schema tests:

## Traditions

Permissive:

- [x] Insert:
  - Public traditions.
  - Private traditions.
- [x] Select:
  - System traditions.
  - Public traditions.
  - Private traditions they own.
- [x] Update: Based on ownership.
- [x] Delete: Deletion is not allowed.

Restrictive:

- [x] Insert: System tradition creation.
- [x] Select: Private traditions user does not own.
- [x] Update: Only traditions the user owns.
- [x] Delete: Deletion is not allowed.

## User Traditions

Permissive:

- [x] Insert: Users can add a user tradition.
- [x] Select: Based on ownership.
- [x] Update: Based on ownership.
- [x] Delete: Based on ownership.

Restrictive:

- [x] Insert: Cannot fake other user ID.
- [x] Select: Cannot select other users.
- [x] Update: Cannot update other users.
- [x] Delete: Cannot delete other users.

## Tradition Prep Steps

- [x] Insert:
  - Custom Steps = Anyone.
  - Default Steps = Tradition Owner.
  - Check step type for non default.
- [x] Select:
  - Default steps.
  - Your custom steps.
  - Not other people's custom steps.
- [x] Update:
  - Your steps only.
- [x] Delete:
  - Your steps only.

## Prep Step Completion

- [x] Insert:
  - Viewable Steps Only.
- [x] Select:
  - Completion Step Owners.
- [x] Update:
  - Your Steps Only.
- [x] Delete:

  - Your Steps Only.

  ## Tradition Date Rules

- [x] Insert:
  - Based on tradition ownership.
- [x] Select:
  - Viewable based on traditions which are viewable.
- [x] Update:
  - Based on tradition ownership.
- [x] Delete:
  - Based on tradition ownership.

## Tradition Occurrences

- [x] Insert:
  - Not allowed.
- [x] Select:
  - Based on tradition permissions.
- [x] Update:
  - Not allowed.
- [x] Delete:
  - Not allowed.
