// Node.js 20+ has native fetch support

// Supabase configuration
const SUPABASE_URL = 'https://yyvoavzgapsyycjwirmg.supabase.co';
const ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyOTgyMzgsImV4cCI6MjA3MDg3NDIzOH0.BFyQKQxyU9pRDQxKQEOdxxVu3XzoOHcKL7qdKGZCgKM';
const SERVICE_ROLE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NTI5ODIzOCwiZXhwIjoyMDcwODc0MjM4fQ.Ti7KodfacWNnP3uaGieYTnfuYgc8Bq3euM7FU00n6fQ';

async function testPushNotification() {
  console.log('🚀 Starting comprehensive push notification tests...\n');

  // Test 1: Get a real FCM token from database
  console.log('📱 Test 1: Fetching a real FCM token from database...');
  try {
    const tokenResponse = await fetch(`${SUPABASE_URL}/rest/v1/user_devices?is_active=eq.true&fcm_token=not.is.null&limit=1`, {
      headers: {
        'apikey': SERVICE_ROLE_KEY,
        'Authorization': `Bearer ${SERVICE_ROLE_KEY}`
      }
    });

    if (!tokenResponse.ok) {
      throw new Error(`Failed to fetch tokens: ${await tokenResponse.text()}`);
    }

    const devices = await tokenResponse.json();
    console.log(`✅ Found ${devices.length} device(s) with FCM tokens`);

    if (devices.length === 0) {
      console.log('⚠️ No devices with FCM tokens found in database');
      return;
    }

    const testToken = devices[0].fcm_token;
    console.log(`📱 Using token: ${testToken.substring(0, 30)}...`);

    // Test 2: Send a test push notification
    console.log('\n📤 Test 2: Sending test push notification...');
    const notificationResponse = await fetch(`${SUPABASE_URL}/functions/v1/send-push-notification`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${ANON_KEY}`
      },
      body: JSON.stringify({
        tokens: [testToken],
        notification: {
          title: 'בדיקת התראות פוש 🎉',
          body: 'ההתראות פוש עובדות מצוין! הכל תוקן בהצלחה!'
        },
        data: {
          type: 'test',
          timestamp: new Date().toISOString()
        }
      })
    });

    if (!notificationResponse.ok) {
      const error = await notificationResponse.text();
      throw new Error(`Failed to send notification: ${error}`);
    }

    const result = await notificationResponse.json();
    console.log('✅ Notification sent successfully!');
    console.log('📊 Results:', JSON.stringify(result, null, 2));

  } catch (error) {
    console.error('❌ Test failed:', error.message);
    return;
  }

  // Test 3: Test send_to_all functionality
  console.log('\n🌍 Test 3: Testing send_to_all functionality...');
  try {
    const allResponse = await fetch(`${SUPABASE_URL}/functions/v1/send-push-notification`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${ANON_KEY}`
      },
      body: JSON.stringify({
        send_to_all: true,
        notification: {
          title: 'הודעה לכל המשתמשים 📢',
          body: 'זוהי בדיקת שליחה לכל המשתמשים הפעילים'
        },
        data: {
          type: 'broadcast',
          timestamp: new Date().toISOString()
        }
      })
    });

    if (!allResponse.ok) {
      const error = await allResponse.text();
      throw new Error(`Failed to send to all: ${error}`);
    }

    const allResult = await allResponse.json();
    console.log('✅ Broadcast notification sent successfully!');
    console.log('📊 Results:', JSON.stringify(allResult, null, 2));

  } catch (error) {
    console.error('❌ Broadcast test failed:', error.message);
  }

  // Test 4: Test with userIds
  console.log('\n👤 Test 4: Testing with userIds...');
  try {
    // First get a user ID from the database
    const userResponse = await fetch(`${SUPABASE_URL}/rest/v1/profiles?limit=1`, {
      headers: {
        'apikey': SERVICE_ROLE_KEY,
        'Authorization': `Bearer ${SERVICE_ROLE_KEY}`
      }
    });

    if (userResponse.ok) {
      const users = await userResponse.json();
      if (users.length > 0) {
        const userId = users[0].id;
        console.log(`👤 Testing with userId: ${userId}`);

        const userIdResponse = await fetch(`${SUPABASE_URL}/functions/v1/send-push-notification`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${ANON_KEY}`
          },
          body: JSON.stringify({
            userIds: [userId],
            notification: {
              title: 'הודעה אישית 👤',
              body: 'זוהי הודעה שנשלחה לפי מזהה משתמש'
            },
            data: {
              type: 'user_specific',
              timestamp: new Date().toISOString()
            }
          })
        });

        if (!userIdResponse.ok) {
          const error = await userIdResponse.text();
          throw new Error(`Failed to send to userId: ${error}`);
        }

        const userIdResult = await userIdResponse.json();
        console.log('✅ User-specific notification sent successfully!');
        console.log('📊 Results:', JSON.stringify(userIdResult, null, 2));
      }
    }
  } catch (error) {
    console.error('❌ UserId test failed:', error.message);
  }

  console.log('\n✨ All tests completed!');
}

// Run the test
testPushNotification().catch(console.error);