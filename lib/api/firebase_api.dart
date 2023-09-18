import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging_web/firebase_messaging_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tut/responsive/mobile_screen_layout.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:restart_app/restart_app.dart';

import '../log/test_logger.dart';
import 'notification.dart';

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
  }
}


class FirebaseWebApi{

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    Future<void> initNotifications() async {
      try {
        //await _firebaseMessaging.requestPermission();
        final FCMToken;
        FCMToken = await _firebaseMessaging.getToken();
        print('Token : $FCMToken');
        logger.e('Token : $FCMToken');
      }catch(e){
        logger.w(e.toString());
        logger.w(e.toString());
        logger.w(e.toString());
        logger.w(e.toString());
        logger.w(e.toString());
        logger.w(e.toString());
        logger.w(e.toString());
        logger.w(e.toString());
        Restart.restartApp();
      }
    //FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    }

}