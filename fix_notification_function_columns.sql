-- תיקון הפונקציה create_simple_notification לשימוש בעמודות הנכונות
CREATE OR REPLACE FUNCTION create_simple_notification()
RETURNS TRIGGER AS $$
DECLARE
    notification_title TEXT;
    notification_body TEXT;
    content_type TEXT;
    anon_key TEXT;
    request_id BIGINT;
    v_title TEXT;
BEGIN
    -- Get the anon key for authentication
    anon_key := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyOTgyMzgsImV4cCI6MjA3MDg3NDIzOH0.BFyQKQxyU9pRDQxKQEOdxxVu3XzoOHcKL7qdKGZCgKM';

    -- Determine content type from table name
    CASE TG_TABLE_NAME
        WHEN 'gallery_albums' THEN
            content_type := 'תמונות';
            -- Use name_he instead of name
            SELECT name_he INTO v_title
            FROM gallery_albums WHERE id = NEW.id;
        WHEN 'tutorials' THEN
            content_type := 'סרטונים';
            SELECT title INTO v_title
            FROM tutorials WHERE id = NEW.id;
        WHEN 'updates' THEN
            content_type := 'עדכון';
            SELECT title INTO v_title
            FROM updates WHERE id = NEW.id;
        WHEN 'whatsapp_groups' THEN
            content_type := 'קבוצת WhatsApp';
            SELECT group_name INTO v_title
            FROM whatsapp_groups WHERE id = NEW.id;
        WHEN 'products' THEN
            content_type := 'מוצר';
            SELECT name INTO v_title
            FROM products WHERE id = NEW.id;
        WHEN 'music_albums' THEN
            content_type := 'אלבום מוזיקה';
            SELECT album_name INTO v_title
            FROM music_albums WHERE id = NEW.id;
        ELSE
            content_type := 'תוכן חדש';
            v_title := '';
    END CASE;

    -- Build notification title and body
    notification_title := content_type || ' חדש!';

    IF v_title IS NOT NULL AND v_title != '' THEN
        notification_body := v_title;
    ELSE
        notification_body := 'תוכן חדש נוסף לאפליקציה';
    END IF;

    -- Call the Edge Function
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

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- בדיקת הטריגרים הקיימים
SELECT
    trigger_name,
    event_object_table as table_name,
    action_statement as function_called
FROM information_schema.triggers
WHERE trigger_name LIKE '%notification%'
ORDER BY event_object_table;