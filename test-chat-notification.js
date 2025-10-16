// בדיקת התראות פוש על הודעות צ'אט
const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = 'https://yyvoavzgapsyycjwirmg.supabase.co';
const SERVICE_ROLE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NTI5ODIzOCwiZXhwIjoyMDcwODc0MjM4fQ.Ti7KodfacWNnP3uaGieYTnfuYgc8Bq3euM7FU00n6fQ';

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

async function testChatNotification() {
  console.log(`💬 Testing chat message push notifications...\n`);

  try {
    // 1. Get an existing conversation
    console.log('1️⃣ מחפש שיחה קיימת...');
    const { data: conversations, error: convError } = await supabase
      .from('conversations')
      .select('id, name, type')
      .limit(1);

    if (convError || !conversations || conversations.length === 0) {
      console.log('⚠️ לא נמצאו שיחות. יוצר שיחה חדשה...');

      // Get two users for the conversation
      const { data: users } = await supabase
        .from('users')
        .select('id')
        .limit(2);

      if (!users || users.length < 2) {
        console.error('❌ לא מספיק משתמשים למבחן');
        return;
      }

      // Create a test conversation
      const { data: newConv, error: createError } = await supabase
        .from('conversations')
        .insert({
          type: 'direct',
          name: 'בדיקת התראות'
        })
        .select()
        .single();

      if (createError) {
        console.error('❌ שגיאה ביצירת שיחה:', createError);
        return;
      }

      // Add participants
      await supabase.from('conversation_participants').insert([
        { conversation_id: newConv.id, user_id: users[0].id },
        { conversation_id: newConv.id, user_id: users[1].id }
      ]);

      conversations[0] = newConv;
    }

    const conversation = conversations[0];
    console.log('✅ נמצאה שיחה:', conversation.id);

    // 2. Get participants
    const { data: participants } = await supabase
      .from('conversation_participants')
      .select('user_id')
      .eq('conversation_id', conversation.id);

    if (!participants || participants.length < 2) {
      console.error('❌ לא מספיק משתתפים בשיחה');
      return;
    }

    console.log(`✅ נמצאו ${participants.length} משתתפים`);

    // 3. Send a test message
    console.log('\n2️⃣ שולח הודעת בדיקה...');
    const { data: message, error: msgError } = await supabase
      .from('messages')
      .insert({
        conversation_id: conversation.id,
        sender_id: participants[0].user_id,
        content: '🧪 הודעת בדיקה - התראות פוש על צ'אט - ' + new Date().toISOString(),
        is_system_message: false
      })
      .select()
      .single();

    if (msgError) {
      console.error('❌ שגיאה בשליחת הודעה:', msgError);
      return;
    }

    console.log('✅ הודעה נשלחה:', message.id);
    console.log('📱 הטריגר היה אמור להפעיל שליחת התראה פוש עכשיו...');

    // 4. Wait and check debug logs
    console.log('\n⏰ ממתין 3 שניות...');
    await new Promise(resolve => setTimeout(resolve, 3000));

    console.log('\n3️⃣ בודק debug logs...');
    const { data: logs } = await supabase
      .from('debug_logs')
      .select('*')
      .eq('content_id', message.id)
      .order('created_at', { ascending: false })
      .limit(5);

    if (logs && logs.length > 0) {
      console.log('✅ נמצאו לוגים:');
      logs.forEach(log => {
        console.log(`   📝 ${log.log_message}`);
      });
    } else {
      console.log('⚠️ לא נמצאו לוגים - יכול להיות שהטריגר לא עבד');
    }

    // 5. Clean up
    console.log('\n4️⃣ מנקה...');
    await supabase.from('messages').delete().eq('id', message.id);
    console.log('✅ הודעה נמחקה');

    console.log('\n💡 האם קיבלת התראה פוש על המכשיר?');
    console.log('   אם כן - ✅ הכל עובד!');
    console.log('   אם לא - בדוק את הלוגים ב:');
    console.log('   https://supabase.com/dashboard/project/yyvoavzgapsyycjwirmg/logs/edge-functions');

  } catch (error) {
    console.error('❌ שגיאה:', error);
  }
}

testChatNotification();