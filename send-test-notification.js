const admin = require('firebase-admin');

// Initialize Firebase Admin (only if not already initialized)
if (!admin.apps.length) {
  const serviceAccount = require('/Users/rontzarfati/Desktop/zaza/zazadance-studio/firebase-notifications-service/firebase-service-account.json');
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
}

async function sendTestNotification() {
  try {
    // Test FCM token for רון צרפתי
    const token = 'fJj3IopF8EUYgOVqhnFMSA:APA91bFUTupw49_9gC2_WY4YkU1IEta82EZTq-YLD6Sb9h7Gi7zaYtnUhE-5EB1vxLRFs-6kP0td3CXGn4AyIu8Y97Ricken14rRx_Z2g4p-Yv86OkfY6i0';

    const message = {
      token: token,
      notification: {
        title: 'בדיקה סופית',
        body: 'המערכת עובדת! התראות פוש על הודעות צאט'
      },
      data: {
        type: 'new_message',
        conversation_id: 'ad7ce5e6-e094-4b6c-947b-d04fbce444d6',
        message_id: 'test-message-id',
        sender_id: '569108dc-547b-46eb-a697-89d5341e485f'
      },
      android: {
        priority: 'high',
        notification: {
          sound: 'default',
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
          channelId: 'high_importance_channel'
        }
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
            contentAvailable: true
          }
        }
      }
    };

    console.log('📤 Sending push notification...');
    const response = await admin.messaging().send(message);
    console.log('✅ Successfully sent message:', response);

    process.exit(0);
  } catch (error) {
    console.error('❌ Error sending message:', error);
    process.exit(1);
  }
}

sendTestNotification();