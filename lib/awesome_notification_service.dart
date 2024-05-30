import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart'
    hide NotificationModel;
import 'package:flutter/services.dart';

class AwesomeNotificationService {
  //
  static const platform = MethodChannel('notifications.manage');

  //
  static initializeAwesomeNotification() async {
    await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        'resource://drawable/rimio_iclauncher',
        [
          appNotificationChannel(
              channelKey: "10001",
              channelName: "RimioApp Notification",),
        ]);
    //requet notifcation permission if not allowed
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // Insert here your friendly dialog box before call the request method
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static Future<void> clearIrrelevantNotificationChannels() async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      // get channels
      final List<dynamic> notificationChannels =
          await platform.invokeMethod('getChannels');

      //confirm is more than the required channels is found
      final notificationChannelNames = notificationChannels
          .map(
            (e) => e.toString().split(" -- ")[1],
          )
          .toList();

      //
      final totalFound = notificationChannelNames
          .where(
            (e) =>
                e.toLowerCase() ==
                appNotificationChannel().channelName!.toLowerCase(),
          )
          .toList();

      if (totalFound.length > 1) {
        //delete all app created notifications
        for (final notificationChannel in notificationChannels) {
          //
          final notificationChannelData = "$notificationChannel".split(" -- ");
          final notificationChannelId = notificationChannelData[0];
          final notificationChannelName = notificationChannelData[1];
          final isSystemOwned =
              notificationChannelName.toLowerCase() == "miscellaneous";
          //
          if (!isSystemOwned) {
            //
            await platform.invokeMethod(
              'deleteChannel',
              {"id": notificationChannelId},
            );
          }
        }

        //
        await initializeAwesomeNotification();
      }
    } on PlatformException catch (e) {
      print("Failed to get notificaiton channels: '${e.message}'.");
    }
  }

  static NotificationChannel appNotificationChannel(
      {channelKey = '10001',
      channelName = 'New Call',
      groupKey = 'group_calls'}) {
    //firebase fall back channel key
    //fcm_fallback_notification_channel
    return  NotificationChannel(
            channelKey: channelKey,
            channelName: channelName,
            channelGroupKey: groupKey,
            groupKey: groupKey,
            criticalAlerts: true,
            channelDescription: 'Notification channel for app',
            importance: NotificationImportance.High,
            playSound: true,
          );
  }

  //
  static Future<dynamic> getNotifications() async {
    //
    // final notificationsStringList =
    //     (await LocalStorageService.getPrefs()).getString(
    //   AppStrings.notificationsKey,
    // );
    //
    // if (notificationsStringList == null) {
    //   return [];
    // }
    //
    // return (jsonDecode(notificationsStringList) as List)
    //     .asMap()
    //     .entries
    //     .map((notificationObject) {
    //   //
    //   // return NotificationModel(
    //   //   index: notificationObject.key,
    //   //   title: notificationObject.value["title"],
    //   //   body: notificationObject.value["body"],
    //   //   image: notificationObject.value["image"],
    //   //   read: notificationObject.value["read"] is bool
    //   //       ? notificationObject.value["read"]
    //   //       : false,
    //   //   timeStamp: notificationObject.value["timeStamp"],
    //   // );
    // }).toList();
  }

  static void addNotification(notification) async {
    //
    final notifications = await getNotifications() ?? [];
    notifications.insert(0, notification);
  }

  static void updateNotification(notificationModel) async {
    //
    final notifications = await getNotifications();
    notifications.removeAt(notificationModel.index);
    notifications.insert(notificationModel.index, notificationModel);
  }

  static showNotification(payload) async {

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(10000),
        channelKey: "10001",
        title: payload['title'],
        criticalAlert: true,
        body: payload['body'],
        icon: "resource://drawable/rimio_iclauncher",
        notificationLayout: NotificationLayout.Default,
        // payload: Map<String, String>.from(payload.toJson()),
      ),
    );
  }

  static getChannelId(type, title) {
    // Random random = new Random();
    // int randomNumber = random.nextInt(1000000);
    // return randomNumber;

    switch (type) {
      case "calls_generated":
        return "10001";
      case "emergency_calls_generated":
        return "10017";
      case "calls_generated_reminder":
        if (title.toString().toLowerCase().contains("2nd request")) {
          return "10002";
        } else if (title.toString().toLowerCase().contains("3rd request")) {
          return "10003";
        } else if (title.toString().toLowerCase().contains("4th request")) {
          return "10004";
        } else {
          return "10005";
        }

      case "condition_correct":
        return "10006";
      case "backup_request":
        return "10007";
      case "backing_you_on_call":
        return "10008";
      case "cancel_call":
        return "10009";
      case "cover_call":
        return "10010";
      case "location_requested":
        return "10011";
      case "location_approved":
        return "10012";
      case "cancel_response":
        return "10013";
      case "call_back_active":
        return "10014";
      case "call_deleted":
        return "10015";
      case "uncorrect_call":
        return "10016";
    }

    return "90000";
  }

  static String getGroupKey(channelId) {
    if (channelId == "10001" ||
        channelId == "10017" ||
        channelId == "10002" ||
        channelId == "10003" ||
        channelId == "10004" ||
        channelId == "10005") {
      return "group_calls";
    } else if (channelId == "10006" ||
        channelId == "10007" ||
        channelId == "10008" ||
        channelId == "10009") {
      return "group_info";
    }
    return "group_other";
  }
}
