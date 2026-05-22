select tradition_occurrences.id as occurrence_id, tradition_prep_steps.id as step_id, tradition_prep_steps.description from tradition_prep_steps
inner join tradition_occurrences on tradition_occurrences.tradition_id = tradition_prep_steps.tradition_id;

-- delete from tradition_prep_steps where id = 'd0459c08-c487-45d4-bdce-b789b4b305c4';

-- update tradition_prep_steps set description = 'Undo Test Step Again' where id = '5d510e21-5143-411e-822e-beb9b4b6cb41';

-- insert into tradition_prep_steps (tradition_id, description, sort_order, step_type)
-- values ('67755040-1ff3-45eb-ad3c-9370368869f4', 'Step 1a', 2, 'custom');

-- insert into tradition_prep_steps (tradition_id, description, sort_order, step_type)
-- values ('c4f0fda5-f0a7-532f-9a5f-a5e52bad00b6', 'Step 1a', 2, 'custom');

-- select * from tradition_prep_steps where tradition_id = '67755040-1ff3-45eb-ad3c-9370368869f4';

-- select * from tradition_prep_steps;