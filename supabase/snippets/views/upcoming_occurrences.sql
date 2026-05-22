drop view if exists upcoming_tradition_occurrences;

create view upcoming_tradition_occurrences 
WITH (security_invoker = true)
as select * from (select distinct on (t.id)
    toc.id as occurrence_id,
    toc.occurs_on,
    t.id as tradition_id,
    t.title,
    t.short_description,
    t.long_description,
    t.is_default,
    t.notes,
    t.visibility,
    ut.id as user_traditions_id,
    ut.reminders_enabled,
    e.id as event_id,
    e.title as event_title,
    e.visibility as event_visibility,
    (
      select jsonb_agg(
        jsonb_build_object(
          'step_id', tps.id, 
          'description', tps.description, 
          'sort_order', tps.sort_order,
          'complete', (select 
            jsonb_build_object(
              'complete_id', usc.id,
              'is_complete', usc.is_complete
            )
            from user_steps_complete usc
            where usc.step_id = tps.id and usc.occurrence_id = toc.id
            limit 1
          )
        ))
      from tradition_prep_steps tps
      where tps.tradition_id = t.id
    ) as prep_steps
  from
    tradition_occurrences toc
    left join traditions t on toc.tradition_id = t.id
    left join user_traditions ut on t.id = ut.tradition_id
    left join events e on t.event_id = e.id
  order by t.id, occurs_on) as subquery
  order by occurs_on;

