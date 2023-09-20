import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tut/main.dart';
import 'package:flutter_tut/responsive/mobile_screen_layout.dart';
import 'package:flutter_tut/responsive/responsive_layout.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/utils/utils.dart';
import 'package:http/http.dart';
import 'package:restart_app/restart_app.dart';

import '../log/test_logger.dart';
import 'notification.dart';

int exceptionRetryCnt = 0;

Future<void> handleBackgroundMessage(RemoteMessage message)  async{
  logger.e('Title : ${message.notification?.title}');
  logger.e('notiType : ${message.data['notiType']}');
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

      //var url = Uri.https(fcmServerPutTokenUrl, 'application/json');
      var url = Uri.parse(fcmServerPutTokenUrl);
      Map<String,String> headerInfo = {'Content-Type':'application/json'};
      var reqBody = jsonEncode({'token': FCMToken, 'uid':'' , 'platform':'web'});
      print("call url ${url}");

      var response = await post(
        url,
        headers: headerInfo,
        body: reqBody,
      );

      FlutterLocalNotification.init();
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

