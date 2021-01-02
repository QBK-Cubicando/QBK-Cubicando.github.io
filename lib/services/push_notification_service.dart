import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:qbk_simple_app/a_screens_pages/drawer_home_page/my_friends.dart';
import 'package:qbk_simple_app/models/user.dart';

class PushNotificationMessage extends StatefulWidget {
  final Widget child;
  final UserData user;

  const PushNotificationMessage({Key key, this.child, this.user})
      : super(key: key);
  @override
  _PushNotificationMessageState createState() =>
      _PushNotificationMessageState();
}

class _PushNotificationMessageState extends State<PushNotificationMessage> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  StreamSubscription iosSubscription;
  @override
  void initState() {
    try {
      if (Platform.isIOS) {
        iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
          _saveDeviceToken();
        });
        _fcm.requestNotificationPermissions(IosNotificationSettings());
      } else {
        _saveDeviceToken();
      }
    } catch (e) {
      print(e);
      _saveDeviceToken();
    }

    _fcm.configure(
      /// Called when the app is in the foreground and we receive a notification
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        final SnackBar snackBar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'Go',
            onPressed: () {
              Navigator.pushNamed(context, MyFriends.id);
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },

      /// Called when the app is in the background and we click on a notification
      onResume: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },

      /// Called when the app has been closed completely and it's opened
      /// from the push notification
      onLaunch: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onBackgroundMessage: myBackgroundMessageHandler,
    );

    super.initState();
  }

  _saveDeviceToken() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    String fcmToken = await _fcm.getToken();

    if (fcmToken != null) {
      var tokenRef = Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('tokens')
          .document(fcmToken);

      await tokenRef.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform':
            Platform.operatingSystem != null ? Platform.operatingSystem : 'web',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging();
//
//   BuildContext get context => null;
//
//   Future initialize() async {
//     _fcm.configure(
//
//         /// Called when the app is in the foreground and we receive a notification
//         onMessage: (Map<String, dynamic> message) async {
//       print('onMessage: $message');
//     },
//
//         /// Called when the app is in the background and we click on a notification
//         onResume: (Map<String, dynamic> message) async {
//       print('onMessage: $message');
//     },
//
//         /// Called when the app has been closed completely and it's opened
//         /// from the push notification
//         onLaunch: (Map<String, dynamic> message) async {
//       print('onMessage: $message');
//     });
//   }
// }
