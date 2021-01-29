import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp();

export const createMsg = functions.firestore
.document('chat/{msgId}')
.onCreate((snap, context) => {
    admin.messaging().sendToTopic('chat',{
        notification: {
            title: snap.data().username,
            body: snap.data().text,
            clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        }
    });
});
