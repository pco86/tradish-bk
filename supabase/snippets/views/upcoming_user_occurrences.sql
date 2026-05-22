drop view if exists upcoming_user_tradition_occurrences;

create view upcoming_user_tradition_occurrences 
WITH (security_invoker = true)
as select * from (select distinct on (traditions.id)
    tradition_occurrences.id as occurrence_id,
    tradition_occurrences.occurs_on,
    traditions.id as tradition_id,
    traditions.title,
    traditions.short_description,
    traditions.long_description,
    traditions.notes,
    traditions.visibility,
    user_traditions.id as user_traditions_id,
    user_traditions.reminders_enabled,
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
            where usc.step_id = tps.id and usc.occurrence_id = tradition_occurrences.id
            limit 1
          )
        ))
      from tradition_prep_steps tps
      where tps.tradition_id = traditions.id
    ) as prep_steps
  from
    tradition_occurrences
    inner join traditions on tradition_occurrences.tradition_id = traditions.id
    inner join user_traditions on traditions.id = user_traditions.tradition_id
  order by traditions.id) as subquery
  order by occurs_on;

  
