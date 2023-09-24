import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_messaging_web/firebase_messaging_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tut/firebase_options.dart';
import 'package:flutter_tut/responsive/mobile_screen_layout.dart';
import 'package:flutter_tut/utils/global_variables.dart';

import '../log/test_logger.dart';
import 'notification.dart';

Future<void> handleBackgroundMessage(RemoteMessage message)  async{
  logger.i('firebase_api handleBackgroundMessage call');
}

class FirebaseApiInit{
  Future<void> init() async{
    kIsWeb ? FirebaseWebApi().initNotifications() : FirebaseApi().initNotifications();
  }
}

class FirebaseApi{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {


      await _firebaseMessaging.requestPermission();
      await _firebaseMessaging.subscribeToTopic("notice");
      await _firebaseMessaging.subscribeToTopic("message");
      final FCMToken = await _firebaseMessaging.getToken();
      logger.i('FirebaseApi Token : ${FCMToken}');
      try {
        FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          logger.i("onMessage!!Lissten ${message.notification?.title}");
          FlutterLocalNotification.showNotification(
            '${message.notification?.title}',
            '${message.notification?.body}',
          );
        });
      }catch(e){
        loggerNoStack.e('firebase_api.dart FirebaseApi MessageException');
        logger.e(e.toString());
      }
  }
}

class FirebaseWebApi{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    final FCMToken;
    FCMToken = await _firebaseMessaging.getToken();
    logger.i('FirebaseWebApi Token : ${FCMToken}');
  }
}