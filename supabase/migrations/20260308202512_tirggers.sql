set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.copy_tradition_on_favorite()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$

DECLARE new_id uuid;

BEGIN

    INSERT INTO
        traditions (
            user_id,
            title,
            short_description,
            long_description,
            notes,
            visibility
        )
    SELECT 
        auth.uid(), 
        title, 
        short_description, 
        long_description, 
        notes, 
        'private'
    FROM traditions
    WHERE id = new.parent_tradition_id
    RETURNING id INTO new_id;

    NEW.tradition_id := new_id;

    RETURN NEW;

END;
$function$
;


