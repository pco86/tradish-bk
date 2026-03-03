create table
    traditions (
        id uuid primary key default gen_random_uuid (),
        user_id uuid REFERENCES auth.users (id) ON DELETE SET NULL,
        title text not null,
        short_description text,
        long_description text,
        visibility text not null check (visibility IN ('system', 'public', 'private')) default 'private',
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now(),
        deleted_at timestamptz,
        version integer
    );

ALTER TABLE traditions
ADD CONSTRAINT traditions_visibility_creator_check CHECK (
    (
        visibility = 'system'
        AND user_id IS NULL
    )
    OR (
        visibility IN ('public', 'private')
        AND user_id IS NOT NULL
    )
);

create table
    tradition_date_rules (
        id uuid primary key default gen_random_uuid (),
        tradition_id uuid not null unique,
        foreign key (tradition_id) references traditions (id) on delete cascade,
        rule_type text check (
            rule_type IN ('fixed', 'relative', 'computed', 'weekly')
        ),
        algorithm text check (algorithm IN ('easter-western')),
        frequency text check (frequency IN ('weekly', 'monthly', 'yearly')),
        operations text[],
        calendar_type text check (
            calendar_type IN (
                'gregorian',
                'lunar',
                'hebrew',
                'islamic',
                'chinese'
            )
        ),
        relative_tradition_id uuid,
        foreign key (relative_tradition_id) references traditions (id),
        month integer,
        day integer,
        weekday integer,
        week_of_month integer,
        interval integer,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
    );

create table
    tradition_occurrences (
        id uuid primary key default gen_random_uuid (),
        tradition_id uuid not null,
        foreign key (tradition_id) references traditions (id) on delete cascade,
        occurs_on text,
        unique (tradition_id, occurs_on),
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now()
    );

create table
    user_traditions (
        id uuid primary key default gen_random_uuid (),
        user_id uuid not null references auth.users (id) on delete cascade default auth.uid (),
        tradition_id uuid not null references traditions (id) on delete cascade,
        custom_title text,
        notes text,
        reminders_enabled boolean not null default true,
        is_favorite boolean not null default true,
        notification_time time,
        created_at timestamptz default now(),
        unique (user_id, tradition_id)
    );

create table
    tradition_prep_steps (
        id uuid primary key default gen_random_uuid (),
        tradition_id uuid not null,
        foreign key (tradition_id) references traditions (id) on delete cascade,
        -- title text not null,
        description text not null,
        -- offset_days integer not null,
        sort_order integer not null,
        unique (tradition_id, sort_order),
        created_at timestamptz not null default now()
    );

create table
    user_tradition_prep_steps (
        id uuid primary key default gen_random_uuid (),
        user_tradition_id uuid not null references user_traditions (id) on delete cascade,
        foreign key (user_tradition_id) references user_traditions (id) on delete cascade,
        tradition_prep_step_id uuid references tradition_prep_steps (id) on delete cascade,
        -- custom_title text,
        custom_description text,
        -- custom_offset_days integer,
        is_removed boolean not null default false,
        sort_order integer not null,
        created_at timestamptz not null default now(),
        unique (user_tradition_id, tradition_prep_step_id)
    );

create table
    user_steps_complete (
        id uuid primary key default gen_random_uuid (),
        occurrence_id uuid not null,
        foreign key (occurrence_id) references tradition_occurrences (id) on delete cascade,
        user_step_id uuid not null,
        foreign key (user_step_id) references user_tradition_prep_steps (id) on delete cascade,
        is_completed boolean not null default false,
        completed_at timestamptz,
        created_at timestamptz not null default now(),
        updated_at timestamptz not null default now(),
        unique (occurrence_id, user_step_id)
    );

create index on user_traditions (tradition_id);

-- Enable Row Level Security
alter table public.traditions enable row level security;

alter table public.tradition_occurrences enable row level security;

alter table public.tradition_date_rules enable row level security;

alter table public.user_traditions enable row level security;

alter table public.tradition_prep_steps enable row level security;

alter table public.user_tradition_prep_steps enable row level security;

alter table public.user_steps_complete enable row level security;

-- Policies for Traditions
create policy "Tradition selection rules" on traditions for
select
    to authenticated,
    anon using (
        visibility in ('system', 'public')
        OR (
            (
                select
                    auth.uid ()
            ) = user_id
        )
    );

create policy "Users can insert public and private traditions" on traditions for insert
with
    check (
        visibility in ('public', 'private')
        and (
            (
                select
                    auth.uid ()
            ) = user_id
        )
    );

create policy "Admin can insert any traditions" on traditions for insert to service_role
with
    check (true);

create policy "Creators can update their traditions" on traditions for
update to authenticated using (
    (
        select
            auth.uid ()
    ) = user_id
)
with
    check (
        (
            select
                auth.uid ()
        ) = user_id
    );

create policy "Admin can update any traditions" on traditions for
update to service_role using (true)
with
    check (true);

create policy "Creators can delete their traditions" on traditions for delete to authenticated using (
    (
        select
            auth.uid ()
    ) = user_id
);

create policy "Admin can delete any traditions" on traditions for delete to service_role using (true);

-- Policies for Tradition Occurrences
create policy "Occurrences are viewable by everyone" on tradition_occurrences for
select
    to authenticated,
    anon using (true);

-- PCO: Consider removing this policy
-- Policies for Tradition Date Rules
create policy "Date Rules are viewable by everyone" on tradition_date_rules for
select
    to authenticated,
    anon using (true);

-- Polcies for User Traditions
create policy "User traditions are viewable by owner" on user_traditions for
select
    using (
        (
            select
                auth.uid ()
        ) = user_id
    );

create policy "Users can create user traditions" on user_traditions for insert to authenticated
with
    check (
        (
            select
                auth.uid ()
        ) = user_id
    );

create policy "Users can update user traditions" on user_traditions for
update to authenticated using (
    (
        select
            auth.uid ()
    ) = user_id
)
with
    check (
        (
            select
                auth.uid ()
        ) = user_id
    );

create policy "Users can delete user traditions" on user_traditions for delete to authenticated using (
    (
        select
            auth.uid ()
    ) = user_id
);

-- Policies for Tradition Prep Steps
create policy "Tradition Prep Steps are viewable by everyone" on tradition_prep_steps for
select
    to authenticated,
    anon using (true);

-- Polcies for User Tradition Prep Steps
create policy "User tradition prep steps are viewable by owner" on user_tradition_prep_steps for
select
    using (
        exists (
            select
                1
            from
                user_traditions ut
            where
                ut.id = user_tradition_prep_steps.user_tradition_id
                and ut.user_id = (
                    select
                        auth.uid ()
                )
        )
    );

create policy "Users can create user tradition prep steps" on user_tradition_prep_steps for insert to authenticated
with
    check (
        exists (
            select
                1
            from
                user_traditions ut
            where
                ut.id = user_tradition_prep_steps.user_tradition_id
                and ut.user_id = (
                    select
                        auth.uid ()
                )
        )
    );

create policy "Users can update user tradition prep steps" on user_tradition_prep_steps for
update to authenticated using (
    exists (
        select
            1
        from
            user_traditions ut
        where
            ut.id = user_tradition_prep_steps.user_tradition_id
            and ut.user_id = (
                select
                    auth.uid ()
            )
    )
)
with
    check (
        exists (
            select
                1
            from
                user_traditions ut
            where
                ut.id = user_tradition_prep_steps.user_tradition_id
                and ut.user_id = (
                    select
                        auth.uid ()
                )
        )
    );

create policy "Users can delete user tradition prep steps" on user_tradition_prep_steps for delete to authenticated using (
    exists (
        select
            1
        from
            user_traditions ut
        where
            ut.id = user_tradition_prep_steps.user_tradition_id
            and ut.user_id = (
                select
                    auth.uid ()
            )
    )
);

-- create policy "User tradition prep steps insert by owner"
-- on user_tradition_preparation_steps
-- for insert
-- with check (
--     exists (
--         select 1
--         from user_traditions ut
--         where ut.id = user_tradition_preparation_steps.user_tradition_id
--         and ut.user_id = auth.uid()
--     )
-- );
-- Polcies for User Steps Complete
create policy "User tradition prep completion steps are viewable by owner" on user_steps_complete for
select
    using (
        exists (
            select
                1
            from
                user_tradition_prep_steps uts
                join user_traditions ut on ut.id = uts.user_tradition_id
            where
                uts.id = user_steps_complete.user_step_id
                and ut.user_id = (
                    select
                        auth.uid ()
                )
        )
    );

CREATE
OR REPLACE FUNCTION excute_add_occurrences_new_tradition () RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER -- Allows the function to run with the privileges of the user who created it (usually the database owner)
SET
    search_path = public AS $$
DECLARE
    webhook_url TEXT;
    api_key TEXT;
    -- Define other variables if needed
BEGIN
    -- Retrieve the secret values from the vault.decrypted_secrets view
    SELECT decrypted_secret INTO webhook_url FROM vault.decrypted_secrets WHERE name = 'add_occurrences_new_tradition';
    SELECT decrypted_secret INTO api_key FROM vault.decrypted_secrets WHERE name = 'webhook_secret';

    IF webhook_url is null then
        return null;
    end if;

    if api_key is null then
        return null;
    end if;

    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    PERFORM net.http_post(
        url := webhook_url,
        body := to_jsonb(NEW),
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'X-Webhook-Secret', 'Bearer ' || api_key
        )
    );

    RETURN NEW;
END;
$$;

CREATE TRIGGER add_occurrences_new_tradition
AFTER INSERT ON public.tradition_date_rules FOR EACH ROW
EXECUTE FUNCTION excute_add_occurrences_new_tradition ();

CREATE
OR REPLACE FUNCTION schedule_occurrence_generation () RETURNS void LANGUAGE plpgsql SECURITY DEFINER -- Allows the function to run with the privileges of the user who created it (usually the database owner)
SET
    search_path = public AS $$
DECLARE
    webhook_url TEXT;
    api_key TEXT;
    -- Define other variables if needed
BEGIN
    -- Retrieve the secret values from the vault.decrypted_secrets view
    SELECT decrypted_secret INTO webhook_url FROM vault.decrypted_secrets WHERE name = 'schedule_occurrence_generation';
    SELECT decrypted_secret INTO api_key FROM vault.decrypted_secrets WHERE name = 'webhook_secret';

    IF webhook_url is null then
        return;
    end if;

    if api_key is null then
        return;
    end if;

    -- Perform the HTTP POST request using pg_net
    -- The 'NEW' variable contains the new row data that triggered the action, used here as the body
    PERFORM net.http_post(
        url := webhook_url,
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'X-Webhook-Secret', 'Bearer ' || api_key
        )
    );
END;
$$;

CREATE EXTENSION IF NOT EXISTS pg_cron;

select
    cron.schedule (
        'schedule-materialization',
        '0 0 * * *',
        'SELECT public.schedule_occurrence_generation()'
    );

create
or replace function set_updated_at () returns trigger as $$
begin
  new.updated_at = now();
  new.version = old.version + 1;
  return new;
end;
$$ language plpgsql;

drop trigger if exists traditions_updated on traditions;

create trigger traditions_updated before
update on traditions for each row
execute function set_updated_at ();

create
or replace function copy_steps_on_favorite () returns trigger language plpgsql as $$
begin
  insert into user_tradition_prep_steps(
    user_tradition_id, 
    tradition_prep_step_id, 
    sort_order
  )
  select new.id, id, sort_order from tradition_prep_steps
  where tradition_id = new.tradition_id;
  return new;
end;
$$;

create trigger copy_steps_trigger
after insert on user_traditions for each row
execute function copy_steps_on_favorite ();