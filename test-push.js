const { createClient } = require('@supabase/supabase-js');

// Initialize Supabase
const supabaseUrl = 'https://yyvoavzgapsyycjwirmg.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUyOTgyMzgsImV4cCI6MjA3MDg3NDIzOH0.zAe-2RvFcYqpgvd7LjVEAqNdF8Nuf_kZnCmWcBRIlRE';
const supabase = createClient(supabaseUrl, supabaseKey);

async function testPushNotification() {
  try {
    // Get FCM token for user ליאל צרפתי
    const { data: tokens, error: tokenError } = await supabase
      .from('user_devices')
      .select('fcm_token')
      .eq('user_id', 'fa26d33a-24f0-47da-bea3-5725b464f0c1')
      .eq('is_active', true)
      .not('fcm_token', 'is', null);

    if (tokenError || !tokens || tokens.length === 0) {
      console.error('No FCM tokens found:', tokenError);
      return;
    }

    console.log('Found FCM tokens:', tokens);

    // Now let's test if we can send to these tokens
    // We'll need to use the firebase-notifications-service approach
    console.log('\nTo send push notifications, run this command from firebase-notifications-service directory:');
    console.log('cd /Users/rontzarfati/Desktop/zaza/zazadance-studio/firebase-notifications-service');
    console.log('node -e "const admin = require(\'firebase-admin\'); const serviceAccount = require(\'./firebase-service-account.json\'); admin.initializeApp({credential: admin.credential.cert(serviceAccount)}); admin.messaging().send({token: \'' + tokens[0].fcm_token + '\', notification: {title: \'בדיקה\', body: \'התראת פוש עובדת!\'}, data: {type: \'test\'}}).then(r => console.log(\'Success:\', r)).catch(e => console.error(\'Error:\', e));"');

  } catch (error) {
    console.error('Error:', error);
  }
}

testPushNotification();