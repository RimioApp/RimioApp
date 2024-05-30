// import 'package:flutter/material.dart';
//
// class    {
//
// }



import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'awesome_notification_service.dart';



String messageId = "";


class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  // Shared preferences instance
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // Initialize shared preferences
  Future<void> init() async {
    await FirebaseMessaging.instance
        .requestPermission(sound: true, badge: true, alert: true);
  }

  setUpFirebaseMessaging() async {
    await firebaseMessaging.requestPermission();
    //subscribing to all topic
    firebaseMessaging.subscribeToTopic("all");

    //on notification tap tp bring app back to life
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

    });

    //normal notification listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("new message id: $messageId");
      if (messageId == message.messageId) {
        return;
      }
      print("notification data:${json.encode(message.data)}");
      messageId = message.messageId!;

      AwesomeNotificationService.showNotification(message.data);
    });
  }


}
