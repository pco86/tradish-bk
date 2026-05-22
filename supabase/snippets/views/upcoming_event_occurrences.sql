drop view if exists upcoming_event_occurrences;

create view upcoming_event_occurrences 
WITH (security_invoker = true)
as select * from (select distinct on (e.id)
    eo.id as occurrence_id,
    eo.occurs_on,
    e.id as event_id,
    e.title,
    e.visibility,
    ue.id as user_event_id,
    ue.reminders_enabled,
    t.id as tradition_id,
    t.title as tradition_title,
    t.short_description,
    t.long_description,
    t.is_default,
    ut.id as user_traditions_id,
    ut.reminders_enabled as tradition_reminders_enabled
  from
    event_occurrences eo
    left join events e on eo.event_id = e.id
    left join user_events ue on e.id = ue.event_id
    left join traditions t on t.event_id = eo.event_id 
    left join user_traditions ut on t.id = ut.tradition_id
    left join tradition_prep_steps tps on tps.tradition_id = t.id
  order by e.id, occurs_on) as subquery
  order by occurs_on;

