

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String NOTIFICATION_CHANNEL_ID = "Flutter Fusion Test Channel";
const String NOTIFICATION_CHANNEL_NAME = "Flutter Fusion Test App Notification Channel";
const String NOTIFICATION_CHANNEL_DESC = "Notification channel is used to show local notification for FlutterFusionTest App";

/// singleton class with init logic
class NotificationManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationManager._internal() {
    //init local notification plugin
    initPlugin();
  }

  factory NotificationManager() => notificationManager;

  static final NotificationManager notificationManager =
      NotificationManager._internal();

  Future initPlugin() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        NOTIFICATION_CHANNEL_ID,
        NOTIFICATION_CHANNEL_NAME,
        NOTIFICATION_CHANNEL_DESC,
        importance: Importance.Max,
        priority: Priority.High);

    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();

    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics);
  }
}
