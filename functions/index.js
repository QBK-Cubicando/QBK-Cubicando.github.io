const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

const db = admin.firestore();
const fcm = admin.messaging();

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.senddevices = functions.firestore
    .document("notification/{id}")
    .onCreate((snapshot) => {
        const name = snapshot.get("name");
        const subject = snapshot.get("subject");
        const token = snapshot.get("token");

        const payload = {
            notification: {
                title: "from " + name,
                body: "subject " + subject,
                sound: "default",
            },
        };

        return fcm.sendToDevice(token, payload);
    });

// exports.addFriend = functions.firestore
//     .document("users/{id}/friends/{friendUid}")
//     .onCreate((snapshot) => {
//         const name = snapshot.get("name");
//         const subject = snapshot.get("subject");
//         const token = snapshot.get("token");

//         const payload = {
//             notification: {
//                 title: "from " + name,
//                 body: "subject " + subject,
//                 sound: "default",
//             },
//         };

//         return fcm.sendToDevice(token, payload);
//     });

exports.addFriend = functions.firestore
    .document("users/{id}/pending/{id}")
    .onCreate((snapshot) => {
        const name = snapshot.get("name");
        const city = snapshot.get("city");
        const speciality = snapshot.get("speciality");
        const friendUid = snapshot.get("friendUid");
        const userUid = snapshot.get("userUid");
        const token = 'cmHALJEg840:APA91bF6hS0zElPjN3Iema_2OBTxRTlBruTXa4Gy_hXUUj_K1tkvQonFfMr1QRTSXNo6VqBGf5N6WDO7ubyMNLCUckzBQC4E_kAl3_xYzGDMip7JhK10i4wDEdjMuOgtf04SxZKr17rW';

        const payload = {
            notification: {
                title: "from " + name,
                body: "subject " + city + speciality + userUid + friendUid,
                sound: "default",
            },
        };

        return fcm.sendToDevice(token, payload);
    });


// exports.sendNotification = functions.firestore
//     .document('users/{userUid}/friends/{firendUid}')
//     .onCreate((snap, context) => {
//         console.log('----------------start function--------------------')

//         const doc = snap.data()
//         console.log(doc)

//         const userUid = doc.userUid
//         const friendUid = doc.frienduid
//         const accepted = doc.accepted

//         // Get push token user to (receive)
//         admin
//             .firestore()
//             .collection('users')
//             .where('id', '==', friendUid)
//             .get()
//             .then(querySnapshot => {
//                 querySnapshot.forEach(friend => {
//                     console.log(`Found friend to: ${friend.data().name}`)

//                     //Get the list of tokens of a friend
//                     // const tokensList = await friend.collection('tokens').get().then((querySnapshot) => {
//                     //     const tokens = []
//                     //     querySnapshot.forEach((doc) => {
//                     //         teokens.push(doc.token)
//                     //     });
//                     //     return tokens;
//                     // });

//                     const tokensList =
//                         `ceGbIcD3ffU:APA91bG4ZBEOHatKcWP2d9yEfexAk-n8yW4l8qpj5v8_OBGSuQW1kK3XoTo5qAywLn9H5IOEwLej0_WrlOBDlu8jaEEDat-9w4JV3P7D3cfPjcIRk5mnMK2uTe1QAmkzGpAjWll6Ssvd`;
//                     console.log(`Tokens List: ${tokenslist}`)

//                     if (tokensList.length > 0) {

//                         // Get info user from (sent)
//                         admin
//                             .firestore()
//                             .collection('users')
//                             .where('id', '==', userUid)
//                             .get()
//                             .then(querySnapshot2 => {
//                                 querySnapshot2.forEach(sender => {
//                                     console.log(`Found user from: ${sender.data().name}`)
//                                     const payload = {
//                                         notification: {
//                                             title: `${sender.data().name} sent you a friend request`,
//                                             body: `${sender.data().name} ${sender.data().speciality}`,
//                                             badge: '1',
//                                             sound: 'default'
//                                         }
//                                     }
//                                     // Let push to the target device
//                                     admin
//                                         .messaging()
//                                         .sendToDevice(tokensList, payload)
//                                         .then(response => {
//                                             console.log('Successfully sent message:', response)
//                                         })
//                                         .catch(error => {
//                                             console.log('Error sending message:', error)
//                                         })
//                                 })
//                             })
//                     } else {
//                         console.log('Can not find Tokens List friend')
//                     }
//                 })
//             })
//         return null
//     })

