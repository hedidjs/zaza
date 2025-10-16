// Simple chat notification test
const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = 'https://yyvoavzgapsyycjwirmg.supabase.co';
const SERVICE_ROLE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl5dm9hdnpnYXBzeXljandpcm1nIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NTI5ODIzOCwiZXhwIjoyMDcwODc0MjM4fQ.Ti7KodfacWNnP3uaGieYTnfuYgc8Bq3euM7FU00n6fQ';

const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);

async function test() {
  console.log('Testing chat message notifications...\n');

  // Get a conversation
  const { data: convs } = await supabase
    .from('conversations')
    .select('id')
    .limit(1);

  if (!convs || convs.length === 0) {
    console.log('No conversations found');
    return;
  }

  const convId = convs[0].id;
  console.log('Using conversation:', convId);

  // Get participants
  const { data: parts } = await supabase
    .from('conversation_participants')
    .select('user_id')
    .eq('conversation_id', convId)
    .limit(2);

  if (!parts || parts.length < 2) {
    console.log('Not enough participants');
    return;
  }

  console.log('Found', parts.length, 'participants');

  // Send message
  console.log('\nSending test message...');
  const { data: msg, error } = await supabase
    .from('messages')
    .insert({
      conversation_id: convId,
      sender_id: parts[0].user_id,
      content: 'Test message - ' + new Date().toISOString(),
      is_system_message: false
    })
    .select()
    .single();

  if (error) {
    console.error('Error:', error);
    return;
  }

  console.log('Message sent:', msg.id);
  console.log('Trigger should have fired!');
  console.log('\nWaiting 3 seconds...');

  await new Promise(r => setTimeout(r, 3000));

  // Check logs
  const { data: logs } = await supabase
    .from('debug_logs')
    .select('*')
    .eq('content_id', msg.id);

  if (logs && logs.length > 0) {
    console.log('\nDebug logs found:');
    logs.forEach(l => console.log('  -', l.log_message));
  } else {
    console.log('\nNo debug logs found - trigger might not have worked');
  }

  // Clean up
  await supabase.from('messages').delete().eq('id', msg.id);
  console.log('\nCleaned up test message');
  console.log('\nDid you receive a push notification?');
}

test().catch(console.error);