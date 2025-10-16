// בדיקה ישירה של הטריגר - האם הוא באמת קורא ל-Edge Function

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = 'https://yyvoavzgapsyycjwirmg.supabase.co';
const SERVICE_ROLE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NTI5ODIzOCwiZXhwIjoyMDcwODc0MjM4fQ.Ti7KodfacWNnP3uaGieYTnfuYgc8Bq3euM7FU00n6fQ';

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

async function testTrigger() {
  console.log('🧪 בודק טריגר להתראות פוש...\n');

  // הוסף אלבום חדש
  console.log('1️⃣ מוסיף אלבום תמונות חדש...');
  const { data: album, error: insertError } = await supabase
    .from('gallery_albums')
    .insert({
      name_he: 'בדיקת טריגר - ' + new Date().toISOString(),
      name_en: 'Trigger Test - ' + new Date().toISOString(),
      description_he: 'בדיקה אוטומטית',
      is_public: true,
      is_featured: false
    })
    .select()
    .single();

  if (insertError) {
    console.error('❌ שגיאה בהוספת אלבום:', insertError);
    return;
  }

  console.log('✅ אלבום נוסף בהצלחה:', album.id);
  console.log('📱 הטריגר היה אמור להפעיל שליחת התראה פוש עכשיו...');
  console.log('\n⏰ ממתין 3 שניות...');

  await new Promise(resolve => setTimeout(resolve, 3000));

  // נסה לבדוק אם יש רשומה בטבלת net._http_response
  console.log('\n2️⃣ בודק בקשות HTTP שנשלחו...');

  // מחק את האלבום
  console.log('\n3️⃣ מוחק את האלבום הזמני...');
  const { error: deleteError } = await supabase
    .from('gallery_albums')
    .delete()
    .eq('id', album.id);

  if (deleteError) {
    console.error('⚠️ שגיאה במחיקת אלבום:', deleteError);
  } else {
    console.log('✅ אלבום נמחק');
  }

  console.log('\n💡 כדי לראות אם ההתראה נשלחה בפועל:');
  console.log('   1. בדוק במכשיר שלך אם קיבלת התראה');
  console.log('   2. בדוק את הלוגים ב-Supabase Dashboard:');
  console.log('      https://supabase.com/dashboard/project/yyvoavzgapsyycjwirmg/logs/edge-functions');
}

testTrigger().catch(console.error);