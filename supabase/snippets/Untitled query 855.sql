select occurs_on, events.title, events.id from event_occurrences
join events on events.id = event_id