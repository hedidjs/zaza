-- תיקון סופי של create_simple_notification עם השמות הנכונים של העמודות

CREATE OR REPLACE FUNCTION create_simple_notification()
RETURNS TRIGGER AS $$
DECLARE
    notification_title TEXT;
    notification_body TEXT;
    content_type TEXT;
    anon_key TEXT;
    request_id BIGINT;
    v_title TEXT;
    v_notification_type TEXT;
    v_action_url TEXT;
    v_user_record RECORD;
BEGIN
    anon_key := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyOTgyMzgsImV4cCI6MjA3MDg3NDIzOH0.BFyQKQxyU9pRDQxKQEOdxxVu3XzoOHcKL7qdKGZCgKM';

    -- Match exact column names from database!
    CASE TG_TABLE_NAME
        WHEN 'gallery_albums' THEN
            content_type := 'gallery_album';
            v_notification_type := 'general';
            SELECT name_he INTO v_title FROM gallery_albums WHERE id = NEW.id;
            notification_title := 'תמונות חדשות!';
            v_action_url := '/gallery-album/' || NEW.id::text;
        WHEN 'tutorials' THEN
            content_type := 'tutorial';
            v_notification_type := 'tutorial';
            SELECT title_he INTO v_title FROM tutorials WHERE id = NEW.id;
            notification_title := 'סרטון חדש!';
            v_action_url := '/tutorial/' || NEW.id::text;
        WHEN 'updates' THEN
            content_type := 'update';
            v_notification_type := 'update';
            SELECT title_he INTO v_title FROM updates WHERE id = NEW.id;
            notification_title := 'עדכון חדש!';
            v_action_url := '/update/' || NEW.id::text;
        WHEN 'whatsapp_groups' THEN
            content_type := 'whatsapp_group';
            v_notification_type := 'general';
            SELECT name INTO v_title FROM whatsapp_groups WHERE id = NEW.id;
            notification_title := 'קבוצת WhatsApp חדשה!';
            v_action_url := '/groups';
        WHEN 'products' THEN
            content_type := 'product';
            v_notification_type := 'general';
            SELECT name_he INTO v_title FROM products WHERE id = NEW.id;
            notification_title := 'מוצר חדש!';
            v_action_url := '/product/' || NEW.id::text;
        WHEN 'music_albums' THEN
            content_type := 'music_album';
            v_notification_type := 'general';
            SELECT name_he INTO v_title FROM music_albums WHERE id = NEW.id;
            notification_title := 'אלבום מוזיקה חדש!';
            v_action_url := '/album/' || NEW.id::text;
        WHEN 'music_tracks' THEN
            content_type := 'music_track';
            v_notification_type := 'general';
            SELECT name_he INTO v_title FROM music_tracks WHERE id = NEW.id;
            notification_title := 'שיר חדש!';
            v_action_url := '/player/' || NEW.id::text;
        ELSE
            content_type := 'general';
            v_notification_type := 'general';
            v_title := '';
            notification_title := 'תוכן חדש!';
            v_action_url := '/';
    END CASE;

    -- Build notification body
    IF v_title IS NOT NULL AND v_title != '' THEN
        notification_body := v_title;
    ELSE
        notification_body := 'תוכן חדש נוסף לאפליקציה';
    END IF;

    -- Create notification record for ALL active users
    FOR v_user_record IN
        SELECT id FROM users WHERE is_approved = true AND is_active = true
    LOOP
        INSERT INTO notifications (
            user_id,
            title_he,
            content_he,
            notification_type,
            action_url,
            content_type,
            content_id,
            metadata,
            is_read
        ) VALUES (
            v_user_record.id,
            notification_title,
            notification_body,
            v_notification_type,
            v_action_url,
            content_type,
            NEW.id::text,
            jsonb_build_object(
                'content_type', content_type,
                'content_id', NEW.id::text,
                'action_url', v_action_url
            ),
            false
        );
    END LOOP;

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
                'action_url', v_action_url,
                'click_action', 'FLUTTER_NOTIFICATION_CLICK'
            )
        )
    ) INTO request_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
