-- delete from tradition_date_rules where id = '98e6586c-c87f-4c6a-bbc5-6ffaa828af59';

-- update tradition_date_rules
-- set month = 5
-- where id = '3b67fd9d-e494-472c-985d-794a43f136f6';

insert into tradition_date_rules (tradition_id, rule_type, frequency, month, day )
values ('4306b52f-d729-44d8-b5d6-b2e972b05cc0', 'fixed', 'yearly', 3, 22);

-- select tradition_date_rules.id as rule_id, traditions.id as tradition_id, traditions.title as title, tradition_date_rules.month as month from tradition_date_rules
-- inner join traditions on (tradition_date_rules.tradition_id = traditions.id and traditions.user_id = auth.uid());

-- select tradition_date_rules.id as rule_id, traditions.id as tradition_id, traditions.title as title, tradition_date_rules.month as month from tradition_date_rules
-- inner join traditions on (tradition_date_rules.tradition_id = traditions.id and tradition_id = 'c4f0fda5-f0a7-532f-9a5f-a5e52bad00b6');

-- select * from tradition_date_rules;
-- select * from tradition_date_rules where tradition_id = 'c4f0fda5-f0a7-532f-9a5f-a5e52bad00b6';

-- select * from traditions where ((select auth.uid()) = traditions.user_id and traditions.id = 'c4f0fda5-f0a7-532f-9a5f-a5e52bad00b6');