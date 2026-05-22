drop view if exists event_date_rule_set;

create view event_date_rule_set 
WITH (security_invoker = true)
as select 
    e.title as event_title,
    edr.* as date_rule,
    (
      select jsonb_agg(
        jsonb_build_object(
          'occurs_on', eo.occurs_on
        )
      )
      from event_occurrences eo
      where e.id = eo.event_id and to_json(now())#>>'{}' < eo.occurs_on
    ) as occurrences,
    (
      select jsonb_agg(
        jsonb_build_object(
          'type', edro.type,
          'config', edro.config,
          'sort_order', edro.sort_order
        )
      )
      from event_date_rule_operations edro
      where edr.id = edro.event_date_rule_id
    ) as event_operations
  from
    events e
    join event_date_rules edr on e.id = edr.event_id

