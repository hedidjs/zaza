-- הסרת יצירת רשומות בטבלת notifications מהודעות צ'אט
-- הודעות צ'אט - רק פוש נוטיפיקציה, ללא רשומה בעמוד ההתראות!

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

  -- Build action URL for push notification data
  v_action_url := '/chat/' || NEW.conversation_id::text;

  -- Determine message preview
  v_message_preview := CASE
    WHEN NEW.media_type = 'voice' THEN '🎤 הודעה קולית'
    WHEN NEW.media_url IS NOT NULL THEN '📷 תמונה'
    WHEN NEW.content IS NOT NULL THEN substring(NEW.content, 1, 100)
    ELSE 'הודעה חדשה'
  END;

  -- Get FCM tokens for push notification (no database notifications!)
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

  -- Send ONLY push notification (no database record)
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
