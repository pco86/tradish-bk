SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'add_occurrences_new_tradition';

-- select vault.create_secret(
--   'http://host.docker.internal:54321/functions/v1/add-occurrence-new-tradition',
--   'add_occurrences_new_tradition'
-- );

-- select vault.create_secret(
--   '438e162ebc3c1c4be81d50dbe7fd49358d72276263554ac97f22cc125cd20d0b',
--   'webhook_secret'
-- );

-- SELECT decrypted_secret FROM vault.decrypted_secrets WHERE name = 'webhook_secret';

-- select * from vault.decrypted_secrets;
-- SELECT decrypted_secret INTO webhook_url FROM vault.decrypted_secrets WHERE name = 'webhook_url';