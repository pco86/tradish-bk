-- delete from traditions where id = 'c4f0fda5-f0a7-532f-9a5f-a5e52bad00b6';

select * from traditions where user_id = auth.uid();
-- select * from traditions where visibility = 'private';
-- select * from traditions where id = 'c4f0fda5-f0a7-532f-9a5f-a5e52bad00b6';
-- select * from traditions; 

-- update traditions set title = 'Carols takeover', visibility = 'private' where id = 'cb9bd2c8-0b8c-47e0-a674-546d8bab16d3'

-- INSERT INTO traditions(title, short_description, visibility) 
-- VALUES ('Carols Tradition', 'Lets Party', 'private');

-- INSERT INTO traditions(title, user_id, short_description, visibility) 
-- VALUES ('Public BDAY', auth.uid(),'Lets Party', 'public');