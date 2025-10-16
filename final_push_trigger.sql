-- תיקון סופי של action_url לתאימות מלאה עם האפליקציה

-- 1. תיקון הפונקציה notify_new_message
CREATE OR REPLACE FUNCTION notify_new_message()
RETURNS TRIGGER AS $$
DECLARE
  v_sender_name TEXT;
  v_message_preview TEXT;
  v_conversation_type TEXT;
  v_conversation_name TEXT;
  v_anon_key TEXT := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyOTgyMzgsImV4cCI6MjA3MDg3NDIzOH0.BFyQKQxyU9pRDQxKQEOdxxVu3XzoOHcKL7qdKGZCgKM';
  v_tokens TEXT[];
  v_user_count INT := 0;
  v_request_id BIGINT;
  v_receiver_record RECORD;
  v_action_url TEXT;
BEGIN
  -- Skip system messages
  IF NEW.is_system_message = TRUE THEN
    RETURN NEW;
  END IF;

  -- Get sender name
  SELECT COALESCE(display_name, full_name, email) INTO v_sender_name
  FROM users
  WHERE id = NEW.sender_id;

  -- Get conversation details
  SELECT type, name INTO v_conversation_type, v_conversation_name
  FROM conversations
  WHERE id = NEW.conversation_id;

  -- Build action URL - match app routes exactly
  v_action_url := '/chat/' || NEW.conversation_id::text;

  -- Determine message preview
  v_message_preview := CASE
    WHEN NEW.media_type = 'voice' THEN '🎤 הודעה קולית'
    WHEN NEW.media_url IS NOT NULL THEN '📷 תמונה'
    WHEN NEW.content IS NOT NULL THEN substring(NEW.content, 1, 100)
    ELSE 'הודעה חדשה'
  END;

  -- Get recipients who should receive notification
  FOR v_receiver_record IN
    SELECT cp.user_id
    FROM conversation_participants cp
    WHERE cp.conversation_id = NEW.conversation_id
      AND cp.user_id != NEW.sender_id
      AND cp.is_viewing = FALSE
      AND cp.is_muted = FALSE
  LOOP
    -- Create notification record for each recipient
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
      v_receiver_record.user_id,
      v_sender_name,
      v_message_preview,
      'new_message',
      v_action_url,
      'new_message',
      NEW.conversation_id::text,
      jsonb_build_object(
        'conversation_id', NEW.conversation_id::text,
        'message_id', NEW.id::text,
        'sender_id', NEW.sender_id::text,
        'conversation_type', v_conversation_type,
        'conversation_name', v_conversation_name
      ),
      false
    );
  END LOOP;

  -- Get FCM tokens for push notification
  SELECT array_agg(DISTINCT ud.fcm_token)
  INTO v_tokens
  FROM conversation_participants cp
  INNER JOIN user_devices ud ON ud.user_id = cp.user_id
  WHERE cp.conversation_id = NEW.conversation_id
    AND cp.user_id != NEW.sender_id
    AND cp.is_viewing = FALSE
    AND cp.is_muted = FALSE
    AND ud.fcm_token IS NOT NULL
    AND ud.is_active = true;

  v_user_count := COALESCE(array_length(v_tokens, 1), 0);

  -- Send push notification if there are tokens
  IF v_user_count > 0 THEN
    SELECT net.http_post(
      url := 'https://yyvoavzgapsyycjwirmg.supabase.co/functions/v1/send-push-notification',
      headers := jsonb_build_object(
        'Content-Type', 'application/json',
        'Authorization', 'Bearer ' || v_anon_key
      ),
      body := jsonb_build_object(
        'tokens', v_tokens,
        'notification', jsonb_build_object(
          'title', v_sender_name,
          'body', v_message_preview
        ),
        'data', jsonb_build_object(
          'type', 'new_message',
          'content_type', 'new_message',
          'content_id', NEW.conversation_id::text,
          'conversation_id', NEW.conversation_id::text,
          'message_id', NEW.id::text,
          'action_url', v_action_url,
          'conversation_type', v_conversation_type,
          'conversation_name', v_conversation_name
        )
      )
    ) INTO v_request_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. תיקון הפונקציה create_simple_notification
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

    -- Match app routes exactly
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
            SELECT title INTO v_title FROM tutorials WHERE id = NEW.id;
            notification_title := 'סרטון חדש!';
            v_action_url := '/tutorial/' || NEW.id::text;
        WHEN 'updates' THEN
            content_type := 'update';
            v_notification_type := 'update';
            SELECT title INTO v_title FROM updates WHERE id = NEW.id;
            notification_title := 'עדכון חדש!';
            v_action_url := '/update/' || NEW.id::text;
        WHEN 'whatsapp_groups' THEN
            content_type := 'whatsapp_group';
            v_notification_type := 'general';
            SELECT group_name INTO v_title FROM whatsapp_groups WHERE id = NEW.id;
            notification_title := 'קבוצת WhatsApp חדשה!';
            v_action_url := '/groups';
        WHEN 'products' THEN
            content_type := 'product';
            v_notification_type := 'general';
            SELECT name INTO v_title FROM products WHERE id = NEW.id;
            notification_title := 'מוצר חדש!';
            v_action_url := '/product/' || NEW.id::text;
        WHEN 'music_albums' THEN
            content_type := 'music_album';
            v_notification_type := 'general';
            SELECT album_name INTO v_title FROM music_albums WHERE id = NEW.id;
            notification_title := 'אלבום מוזיקה חדש!';
            v_action_url := '/album/' || NEW.id::text;
        WHEN 'music_tracks' THEN
            content_type := 'music_track';
            v_notification_type := 'general';
            SELECT track_name INTO v_title FROM music_tracks WHERE id = NEW.id;
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
