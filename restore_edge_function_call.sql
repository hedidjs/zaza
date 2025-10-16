-- החזרת create_simple_notification לקרוא ל-Edge Function

CREATE OR REPLACE FUNCTION public.create_simple_notification()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
AS $function$
DECLARE
    notification_title TEXT;
    notification_body TEXT;
    content_type TEXT;
    content_name TEXT;
    anon_key TEXT := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyOTgyMzgsImV4cCI6MjA3MDg3NDIzOH0.zAe-2RvFcYqpgvd7LjVEAqNdF8Nuf_kZnCmWcBRIlRE';
    user_count INTEGER;
    request_id BIGINT;
BEGIN
    -- Determine content type and title from table
    CASE TG_TABLE_NAME
        WHEN 'gallery_albums' THEN
            content_type := 'album';
            notification_title := 'אלבום תמונות חדש! 📸';
            SELECT name INTO content_name FROM gallery_albums WHERE id = NEW.id;
            notification_body := 'אלבום תמונות חדש זמין: ' || content_name;
        WHEN 'updates' THEN
            content_type := 'update';
            notification_title := 'הודעה חדשה! 📢';
            SELECT title INTO content_name FROM updates WHERE id = NEW.id;
            notification_body := content_name;
        WHEN 'tutorials' THEN
            content_type := 'tutorial';
            notification_title := 'מדריך חדש! 📚';
            SELECT title INTO content_name FROM tutorials WHERE id = NEW.id;
            notification_body := 'מדריך חדש נוסף: ' || content_name;
        WHEN 'whatsapp_groups' THEN
            content_type := 'whatsapp_group';
            notification_title := 'קבוצת וואטסאפ חדשה! 💬';
            SELECT name INTO content_name FROM whatsapp_groups WHERE id = NEW.id;
            notification_body := 'קבוצת וואטסאפ חדשה נפתחה: ' || content_name;
        WHEN 'products' THEN
            content_type := 'product';
            notification_title := 'מוצר חדש במכירה! 🛍️';
            SELECT name INTO content_name FROM products WHERE id = NEW.id;
            notification_body := 'מוצר חדש זמין: ' || content_name;
        WHEN 'music_albums' THEN
            content_type := 'music_album';
            notification_title := 'אלבום מוזיקה חדש! 🎵';
            SELECT name INTO content_name FROM music_albums WHERE id = NEW.id;
            notification_body := 'אלבום מוזיקה חדש זמין: ' || content_name;
        ELSE
            RETURN NEW;
    END CASE;

    -- Insert notifications for all users (except admin)
    INSERT INTO notifications (user_id, title, body, content_type, content_id, created_at, is_read, source)
    SELECT id, notification_title, notification_body, content_type, NEW.id::text, now(), false, 'system'
    FROM users
    WHERE is_admin = false;

    GET DIAGNOSTICS user_count = ROW_COUNT;

    -- Send push notification via Edge Function
    SELECT net.http_post(
        url := 'https://yyvoavzgapsyycjwirmg.supabase.co/functions/v1/send-push-notification',
        headers := jsonb_build_object(
            'Content-Type', 'application/json',
            'Authorization', 'Bearer ' || anon_key
        ),
        body := jsonb_build_object(
            'title', notification_title,
            'body', notification_body,
            'send_to_all', true,
            'from_trigger', true,
            'notification', jsonb_build_object(
                'title', notification_title,
                'body', notification_body
            ),
            'data', jsonb_build_object(
                'type', 'content',
                'content_type', content_type,
                'content_id', NEW.id::text,
                'click_action', 'FLUTTER_NOTIFICATION_CLICK'
            )
        )
    ) INTO request_id;

    INSERT INTO debug_logs (log_message, table_name, content_id)
    VALUES ('EDGE_FUNCTION_CALLED: ' || COALESCE(request_id::text, 'NULL'), TG_TABLE_NAME, NEW.id::text);

    RETURN NEW;
END;
$function$;