drop view if exists upcoming_user_event_occurrences;

create view upcoming_user_event_occurrences 
WITH (security_invoker = true)
as select * from 
(select distinct on (e.id)
    eo.id as occurrence_id,
    eo.occurs_on,
    e.id as event_id,
    e.title,
    e.short_description,
    e.long_description,
    e.visibility,
    ue.id as user_event_id,
    ue.reminders_enabled
  from
    event_occurrences eo
    inner join events e on eo.event_id = e.id
    inner join user_events ue on e.id = ue.event_id
  order by e.id) as subquery
  order by occurs_on;

  
