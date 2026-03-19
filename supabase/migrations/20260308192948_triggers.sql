set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.copy_tradition_on_favorite()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$

BEGIN

    NEW.tradition_id := gen_random_uuid();

    INSERT INTO
        traditions (
            id,
            user_id,
            title,
            short_description,
            long_description,
            notes,
            visibility
        )
    SELECT 
        NEW.tradition_id, 
        auth.uid(), 
        title, 
        short_description, 
        long_description, 
        notes, 
        'private'
    FROM traditions
    WHERE id = new.parent_tradition_id;

    RETURN NEW;

END;
$function$
;

CREATE OR REPLACE FUNCTION public.copy_steps_on_favorite()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$ 
    
BEGIN

    INSERT INTO
        user_tradition_prep_steps(
            user_tradition_id,
            tradition_prep_step_id,
            sort_order
        )
    SELECT new.id, id, sort_order FROM tradition_prep_steps
    WHERE tradition_id = new.parent_tradition_id;

    RETURN new;

END;
$function$
;

CREATE TRIGGER copy_tradition_trigger BEFORE INSERT ON public.user_traditions FOR EACH ROW EXECUTE FUNCTION public.copy_tradition_on_favorite();


