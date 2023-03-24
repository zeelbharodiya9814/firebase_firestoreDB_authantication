



import 'package:firebase_messaging/firebase_messaging.dart';


class FCMNotificationHelper {
  FCMNotificationHelper._();
  static final FCMNotificationHelper fcmNotificationHelper = FCMNotificationHelper._();

  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> getFCMToken() async {
    String? token = await firebaseMessaging.getToken();

    print("==========================");
    print(token);
    print("==========================");
  }
}