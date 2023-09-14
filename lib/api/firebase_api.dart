import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tut/responsive/mobile_screen_layout.dart';
import 'package:flutter_tut/utils/global_variables.dart';

import '../log/test_logger.dart';
import 'notification.dart';
//https://www.youtube.com/watch?v=k0zGEbiDJcQ&ab_channel=HeyFlutter%E2%80%A4com

Future<void> handleBackgroundMessage(RemoteMessage message)  async{
  logger.e('Title : ${message.notification?.title}');
  logger.e('Body : ${message.notification?.body}');
  logger.e('Payload : ${message.data}');


  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    logger.i("onMessage!!Lissten ${message.notification?.title}");
    FlutterLocalNotification.showNotification(
      '${message.notification?.title}',
      '${message.notification?.body}',
    );
  });

}


class FirebaseApi{

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //void configureMessaging() {


    /*
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // 앱이 백그라운드에 있을 때 메시지를 터치하여 앱을 다시 시작한 경우
      logger.i("onMessageOpenedApp: $message");
    });

    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      // 앱이 종료된 경우 메시지를 터치하여 앱을 다시 시작한 경우
      if (message != null) {
        logger.i("getInitialMessage: $message");
      }
    });
  */
  //}

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FCMToken = await _firebaseMessaging.getToken();
    print('Token : $FCMToken');
    logger.e('Token : $FCMToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);


  }

}