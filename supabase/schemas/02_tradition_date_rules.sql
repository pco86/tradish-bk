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