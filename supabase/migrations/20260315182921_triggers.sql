set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.tradition_owner_user_tradition()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
    INSERT INTO 
        user_traditions (
            user_id,
            tradition_id
        )
    VALUES (
        auth.uid(),
        new.id
    );

    RETURN NEW;
END; 
$function$
;


