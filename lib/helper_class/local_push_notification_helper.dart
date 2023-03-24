import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalPushNotificationHelper {
  LocalPushNotificationHelper._();

  static final LocalPushNotificationHelper localPushNotificationHelper =
      LocalPushNotificationHelper._();

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initLocalPushNotification() async {
    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");
    DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (response) {
      print("=============================");
      print("Payload => ${response.payload}");
      print("=============================");
    });
  }

  Future<void> showSimpleNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('Dummy', 'Simple channel',
            priority: Priority.max, importance: Importance.max);
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      1,
      'Simple Notification',
      'simple Body',
      notificationDetails,
      payload: "Simple Notification Payload...",
    );
  }

  Future<void> showScheduledNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Dummy Scheduled',
            'Scheduled channel',
            priority: Priority.max,
            importance: Importance.max
        );
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Scheduled Notification',
      'Scheduled Body',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 3),),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: "Scheduled Notification Payload...",
    );
  }


  Future<void> showBigPictureNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'Dummy BigPicture',
        'BigPicture channel',
        priority: Priority.max,
        importance: Importance.max,
      styleInformation: BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
      ),
    );


    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: null);
    await flutterLocalNotificationsPlugin.show(
      1,
      'BigPicture Notification',
      'BigPicture Body',
      notificationDetails,
      payload: "BigPicture Notification Payload...",
    );
  }



  Future<void> showMediaStyleNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'Dummy MediaStyle',
      'MediaStyle channel',
      priority: Priority.max,
      importance: Importance.max,
      enableLights: true,
      color: Colors.red,
      colorized: true,
      largeIcon: DrawableResourceAndroidBitmap("mipmap/ic_launcher"),
      styleInformation: MediaStyleInformation(),
    );


    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: null);
    await flutterLocalNotificationsPlugin.show(
      1,
      'MediaStyle Notification',
      'MediaStyle Body',
      notificationDetails,
      payload: "MediaStyle Notification Payload...",
    );
  }
}
