import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_web/firebase_messaging_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tut/main.dart';
import 'package:flutter_tut/responsive/mobile_screen_layout.dart';
import 'package:flutter_tut/responsive/responsive_layout.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/utils/utils.dart';
import 'package:restart_app/restart_app.dart';

import '../log/test_logger.dart';
import 'notification.dart';

int exceptionRetryCnt = 0;

Future<void> handleBackgroundMessage(RemoteMessage message)  async{
  logger.e('Title : ${message.notification?.title}');
  logger.e('Body : ${message.notification?.body}');
  logger.e('Payload : ${message.data}');
}


class FirebaseApi{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
      await _firebaseMessaging.requestPermission();
      await _firebaseMessaging.subscribeToTopic("notice");
      await _firebaseMessaging.subscribeToTopic("message");
      final FCMToken = await _firebaseMessaging.getToken();
      print('Token : $FCMToken');
      logger.e('Token : $FCMToken');
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        logger.i("onMessage!!Lissten ${message.notification?.title}");
        FlutterLocalNotification.showNotification(
          '${message.notification?.title}',
          '${message.notification?.body}',
        );
      });
  }
}


class FirebaseWebApi{

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    Future<void> initNotifications() async {
      try {
        //await _firebaseMessaging.requestPermission();
        final FCMToken;
        FCMToken = await _firebaseMessaging.getToken();
        logger.e('Token : $FCMToken');


        NotificationSettings settings = await _firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('Got a message whilst in the foreground!');
          print('Message data: ${message.data}');

          if (message.notification != null) {
            print('Message also contained a notification: ${message.notification}');

            flutterLocalNotificationsPlugin.show(
                1,
                '${message.notification?.title}',
                '${message.notification?.body}',
                null
            );

            //handleBackgroundMessage(message);
          }
        });
        FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      }catch(e){
        if(exceptionRetryCnt < 10) {
          //Restart.restartApp();
          logger.w('FirebaseWebApi().initNotifications() retry' + exceptionRetryCnt.toString());
          FirebaseWebApi().initNotifications();
          exceptionRetryCnt++;
        }
      }
    }

}