create table traditions (  
    id uuid primary key default gen_random_uuid (),  
    title text,  
    short_description text,  
    long_description text,  
    created_at timestamptz not null default now (),  
    updated_at timestamptz not null default now ()  
);  

create table tradition_date_rules (  
    id uuid primary key default gen_random_uuid (),  
    tradition_id uuid not null unique,
    foreign key (tradition_id) references traditions (id) on delete cascade,
    rule_type text check (rule_type IN ('fixed', 'relative', 'computed', 'weekly')),
    algorithm text check (algorithm IN ('easter-western')),
    frequency text check (frequency IN ('weekly', 'monthly', 'yearly')),
    operations text[],   
    calendar_type text check (calendar_type IN ('gregorian', 'lunar', 'hebrew', 'islamic', 'chinese')), 
    relative_tradition_id uuid,
    foreign key (relative_tradition_id) references traditions (id),
    month integer, 
    day integer, 
    weekday integer, 
    week_of_month integer, 
    interval integer, 
    created_at timestamptz not null default now (),  
    updated_at timestamptz not null default now ()  
);  

create table tradition_occurrences (  
    id uuid primary key default gen_random_uuid (),  
    tradition_id uuid not null,
    foreign key (tradition_id) references traditions (id) on delete cascade,
    occurs_on text,  
    unique (tradition_id, occurs_on),
    created_at timestamptz not null default now (),  
    updated_at timestamptz not null default now ()  
);  

-- Enable Row Level Security
alter table public.traditions
enable row level security;
alter table public.tradition_occurrences
enable row level security;
alter table public.tradition_date_rules
enable row level security;

-- Policies for Traditions
create policy "Traditions are viewable by everyone"
on traditions for select
to authenticated, anon
using ( true );

-- Policies for Tradition Occurrences
create policy "Occurrences are viewable by everyone"
on tradition_occurrences for select
to authenticated, anon
using ( true );

-- PCO: Consider removing this policy
-- Policies for Tradition Date Rules
create policy "Date Rules are viewable by everyone"
on tradition_date_rules for select
to authenticated, anon
using ( true );