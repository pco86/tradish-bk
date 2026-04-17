-- INSERT INTO events(title, short_description, visibility) 
-- VALUES ('Christmas 2.0', 'Lets Party', 'system');

-- INSERT INTO traditions(title, short_description, visibility) 
-- VALUES ('Christmas 2.0', 'Lets Party', 'system');

-- select * from events where title = 'Christmas 2.0'

-- delete from events where id = '5fd48d34-abbc-4954-ac12-98245beeda86'

delete from events where title = 'Christmas 2.0';

-- delete from event_date_rules where event_id = '381851be-9134-493c-be15-b74ab8074359'

-- insert into event_date_rules (event_id, rule_type, frequency, month, day )
-- values ('381851be-9134-493c-be15-b74ab8074359', 'fixed', 'yearly', 11, 24);

-- insert into tradition_date_rules (tradition_id, rule_type, frequency, month, day )
-- values ('7ddf89a0-0e19-492e-93ae-d70a5edc7730', 'fixed', 'yearly', 11, 24);