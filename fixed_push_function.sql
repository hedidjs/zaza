CREATE OR REPLACE FUNCTION notify_new_message()
RETURNS TRIGGER AS $$
DECLARE
  v_conversation_participants RECORD;
  v_sender_name TEXT;
  v_tokens TEXT[];
  v_message_preview TEXT;
  v_anon_key TEXT := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyOTgyMzgsImV4cCI6MjA3MDg3NDIzOH0.zAe-2RvFcYqpgvd7LjVEAqNdF8Nuf_kZnCmWcBRIlRE';
BEGIN
  -- Log start of trigger
  RAISE NOTICE '[PUSH_DEBUG] Trigger fired for message %', NEW.id;

  -- Skip system messages
  IF NEW.is_system_message = TRUE THEN
    RAISE NOTICE '[PUSH_DEBUG] Skipping system message';
    RETURN NEW;
  END IF;

  -- Get sender name
  SELECT COALESCE(display_name, full_name, email) INTO v_sender_name
  FROM users WHERE id = NEW.sender_id;

  RAISE NOTICE '[PUSH_DEBUG] Sender: % (ID: %)', v_sender_name, NEW.sender_id;

  -- Create message preview
  v_message_preview := CASE
    WHEN NEW.media_type = 'voice' THEN '🎤 הודעה קולית'
    WHEN NEW.media_url IS NOT NULL THEN '📷 תמונה'
    WHEN NEW.content IS NOT NULL THEN substring(NEW.content, 1, 100)
    ELSE 'הודעה חדשה'
  END;

  RAISE NOTICE '[PUSH_DEBUG] Message preview: %', v_message_preview;

  -- Get all participants except sender who are not viewing and not muted
  FOR v_conversation_participants IN
    SELECT cp.user_id, cp.is_viewing, cp.is_muted
    FROM conversation_participants cp
    WHERE cp.conversation_id = NEW.conversation_id
      AND cp.user_id != NEW.sender_id
  LOOP
    RAISE NOTICE '[PUSH_DEBUG] Checking participant % (viewing: %, muted: %)',
      v_conversation_participants.user_id,
      v_conversation_participants.is_viewing,
      v_conversation_participants.is_muted;

    -- Skip if viewing or muted
    IF v_conversation_participants.is_viewing = TRUE THEN
      RAISE NOTICE '[PUSH_DEBUG] Skipping - user is viewing conversation';
      CONTINUE;
    END IF;

    IF v_conversation_participants.is_muted = TRUE THEN
      RAISE NOTICE '[PUSH_DEBUG] Skipping - conversation is muted';
      CONTINUE;
    END IF;

    -- Get FCM tokens for this user
    SELECT array_agg(fcm_token) INTO v_tokens
    FROM user_devices
    WHERE user_id = v_conversation_participants.user_id
      AND fcm_token IS NOT NULL
      AND is_active = true;

    IF v_tokens IS NULL OR array_length(v_tokens, 1) = 0 THEN
      RAISE NOTICE '[PUSH_DEBUG] No FCM tokens found for user %', v_conversation_participants.user_id;
      CONTINUE;
    END IF;

    RAISE NOTICE '[PUSH_DEBUG] Found % FCM tokens for user %', array_length(v_tokens, 1), v_conversation_participants.user_id;

    -- Try to send notification (without capturing the result as RECORD)
    BEGIN
      PERFORM net.http_post(
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
            'conversation_id', NEW.conversation_id::text,
            'message_id', NEW.id::text,
            'sender_id', NEW.sender_id::text
          ),
          'from_trigger', true
        )
      );

      RAISE NOTICE '[PUSH_DEBUG] HTTP Request sent successfully';

    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE '[PUSH_DEBUG] Error calling Edge Function: %', SQLERRM;
    END;

  END LOOP;

  RAISE NOTICE '[PUSH_DEBUG] Trigger completed for message %', NEW.id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;