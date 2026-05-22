drop view if exists tradition_date_rule_set;

create view tradition_date_rule_set 
WITH (security_invoker = true)
as select 
    t.title as tradition_title,
    t.id as tradition_id,
    t.event_id as event_id,
    edr.frequency as frequency,
    (
      select jsonb_agg(
        jsonb_build_object(
          'occurs_on', tro.occurs_on
        )
      )
      from tradition_occurrences tro
      where t.id = tro.tradition_id and to_json(now())#>>'{}' < tro.occurs_on
    ) as occurrences,
    (
      select jsonb_agg(
        jsonb_build_object(
          'type', tdro.type,
          'config', tdro.config,
          'sort_order', tdro.sort_order
        )
      )
      from tradition_date_rule_operations tdro
      where t.id = tdro.tradition_id
    ) as tradition_operations
  from
    traditions t
    join event_date_rules edr on t.event_id = edr.event_id


