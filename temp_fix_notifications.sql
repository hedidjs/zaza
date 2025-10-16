-- Temporary fix: Update create_simple_notification to NOT call Edge Function
-- This will still create notifications in database but won't send push

CREATE OR REPLACE FUNCTION create_simple_notification()
RETURNS TRIGGER AS $$
DECLARE
    notification_title TEXT;
    notification_body TEXT;
    notification_route TEXT;
    content_type_name TEXT;
    preference_column TEXT;
    user_record RECORD;
    user_count INT;
    existing_notifications_count INT;
    push_already_sent BOOLEAN;
    request_id BIGINT;
    anon_key TEXT := 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyOTgyMzgsImV4cCI6MjA3MDg3NDIzOH0.IU_dW_8K-yuV1grWIWJdetU7jK-b-QDPFYp_m5iFP90';
BEGIN
    -- Determine content type and preference column
    IF TG_TABLE_NAME = 'gallery_albums' THEN
        content_type_name := 'gallery_album';
        preference_column := 'gallery_albums_enabled';
        notification_title := 'אלבום חדש נוצר';
        notification_body := 'אלבום "' || COALESCE(NEW.name_he, 'ללא שם') || '"';
        notification_route := '/gallery-album/' || NEW.id;

    ELSIF TG_TABLE_NAME = 'updates' THEN
        content_type_name := 'update';
        preference_column := 'updates_enabled';
        notification_title := 'עדכון חדש';
        notification_body := COALESCE(NEW.title_he, 'עדכון חדש באפליקציה');
        notification_route := '/updates';

    ELSIF TG_TABLE_NAME = 'tutorials' THEN
        content_type_name := 'tutorial';
        preference_column := 'tutorials_enabled';
        notification_title := 'מדריך חדש';
        notification_body := COALESCE(NEW.title_he, 'מדריך חדש באפליקציה');
        notification_route := '/tutorial/' || NEW.id;

    ELSIF TG_TABLE_NAME = 'whatsapp_groups' THEN
        content_type_name := 'whatsapp_group';
        preference_column := 'whatsapp_groups_enabled';
        notification_title := 'קבוצת וואטסאפ חדשה';
        notification_body := COALESCE(NEW.name_he, 'קבוצה חדשה נוספה');
        notification_route := '/whatsapp-groups';

    ELSIF TG_TABLE_NAME = 'store_products' THEN
        content_type_name := 'product';
        preference_column := 'products_enabled';
        notification_title := 'מוצר חדש בחנות';
        notification_body := COALESCE(NEW.name_he, 'מוצר חדש נוסף לחנות');
        notification_route := '/store';

    ELSIF TG_TABLE_NAME = 'music_albums' THEN
        content_type_name := 'music_album';
        preference_column := 'music_albums_enabled';
        notification_title := 'אלבום מוזיקה חדש';
        notification_body := COALESCE(NEW.name_he, 'אלבום חדש נוסף');
        notification_route := '/album/' || NEW.id;

    ELSE
        RAISE EXCEPTION 'Unsupported table: %', TG_TABLE_NAME;
    END IF;

    -- בדיקה אם כבר שלחנו פוש לתוכן הזה
    SELECT EXISTS(
        SELECT 1 FROM push_sent_tracker
        WHERE content_type = content_type_name
        AND content_id = NEW.id::text
    ) INTO push_already_sent;

    IF push_already_sent THEN
        INSERT INTO debug_logs (log_message, table_name, content_id)
        VALUES ('PUSH_ALREADY_SENT_SKIPPING', TG_TABLE_NAME, NEW.id::text);
        RETURN NEW;
    END IF;

    -- בדיקה אם כבר יצרנו התראות לתוכן הזה
    SELECT COUNT(*) INTO existing_notifications_count
    FROM notifications
    WHERE content_id = NEW.id::text
    AND content_type = content_type_name;

    -- אם כבר יש התראות - לא נעשה כלום!
    IF existing_notifications_count > 0 THEN
        INSERT INTO debug_logs (log_message, table_name, content_id)
        VALUES ('NOTIFICATIONS_EXIST_SKIPPING', TG_TABLE_NAME, NEW.id::text);
        RETURN NEW;
    END IF;

    -- איסוף מספר המשתמשים
    user_count := 0;

    -- יצירת התראות לכל המשתמשים שרוצים התראות מהסוג הזה
    FOR user_record IN
        SELECT u.id
        FROM users u
        LEFT JOIN notification_preferences np ON np.user_id = u.id
        WHERE u.is_active = true
        AND u.email != 'dev@zazadance.com'
        AND u.deleted = false
        AND u.is_approved = true
        AND (
            CASE
                WHEN preference_column = 'updates_enabled' THEN COALESCE(np.updates_enabled, true)
                WHEN preference_column = 'gallery_albums_enabled' THEN COALESCE(np.gallery_albums_enabled, true)
                WHEN preference_column = 'tutorials_enabled' THEN COALESCE(np.tutorials_enabled, true)
                WHEN preference_column = 'whatsapp_groups_enabled' THEN COALESCE(np.whatsapp_groups_enabled, true)
                WHEN preference_column = 'products_enabled' THEN COALESCE(np.products_enabled, true)
                WHEN preference_column = 'music_albums_enabled' THEN COALESCE(np.music_albums_enabled, true)
                ELSE true
            END)
    LOOP
        INSERT INTO notifications (
            title_he,
            content_he,
            content_type,
            content_id,
            deep_link_route,
            user_id
        ) VALUES (
            notification_title,
            notification_body,
            content_type_name,
            NEW.id::text,
            notification_route,
            user_record.id
        );
        user_count := user_count + 1;
    END LOOP;

    INSERT INTO debug_logs (log_message, table_name, content_id)
    VALUES ('NOTIFICATIONS_CREATED_WITH_PREFERENCES: ' || user_count, TG_TABLE_NAME, NEW.id::text);

    -- רישום ששלחנו פוש
    INSERT INTO push_sent_tracker (content_type, content_id)
    VALUES (content_type_name, NEW.id::text)
    ON CONFLICT (content_type, content_id) DO NOTHING;

    -- TEMPORARY: Don't call Edge Function until it's fixed
    -- The notifications are created in database, users will see them when they open the app

    INSERT INTO debug_logs (log_message, table_name, content_id)
    VALUES ('TEMP_SKIP_EDGE_FUNCTION: ' || user_count || ' notifications created', TG_TABLE_NAME, NEW.id::text);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;