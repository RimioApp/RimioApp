import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:Rimio/view/productDetails.dart';
import 'package:awesome_notifications/awesome_notifications.dart'
    hide NotificationModel;
import 'package:flutter/cupertino.dart';
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
            channelName: "RimioApp Notification",
          ),
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

  static Future<void> listenAction(BuildContext context) async {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: (ReceivedAction receivedAction) async {
      var productId = receivedAction.payload!['productId'];
      Navigator.pushNamed(context, ProductDetails.routeName,
          arguments: productId);
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
    return NotificationChannel(
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
    var payloadStr = jsonEncode(payload);
    Map load = jsonDecode(payloadStr);
    List loadList = load.entries.toList();
    Map<String, String?> convertedMap = <String, String?>{};
    for (int index = 0; index < loadList.length; index++) {
      var value = loadList[index].value;
      var key = loadList[index].key;
      convertedMap[key] = value;
    }
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(10000),
        channelKey: "10001",
        title: convertedMap['title'],
        criticalAlert: true,
        body: convertedMap['body'],
        icon: "resource://drawable/rimio_iclauncher",
        notificationLayout: NotificationLayout.Default,
        payload: convertedMap,
      ),
    );
  }
}
