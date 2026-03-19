CREATE POLICY "User tradition prep completion steps are viewable by owner" ON "public"."user_steps_complete" AS permissive FOR
SELECT
  TO public USING (
    (
      EXISTS (
        SELECT
          1
        FROM
          public.tradition_prep_steps tps
        WHERE
          (tps.id = user_steps_complete.step_id)
      )
    )
  );