CREATE UNIQUE INDEX one_default_tradition_per_event ON public.traditions USING btree (event_id)
WHERE
    (is_default = true);