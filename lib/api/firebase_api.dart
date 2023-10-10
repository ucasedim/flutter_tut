import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:firebase_messaging_web/firebase_messaging_web.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/api/firebase_web_api.dart';
import 'package:flutter_tut/firebase_options.dart';
import 'package:flutter_tut/providers/subscribe_widget_provider.dart';
import 'package:flutter_tut/responsive/mobile_screen_layout.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:http/http.dart';

import '../log/test_logger.dart';
import 'notification.dart';

Future<void> handleBackgroundMessage(RemoteMessage message)  async{
  logger.i('firebase_api handleBackgroundMessage call');
  logger.i("background : SubscribeWidgetProvider().option.toMap().containsKey('${message.data['notiType']}");

}

class FirebaseApiInit{
  Future<void> init() async{
    print('kIsWeb : ${kIsWeb}');
    await kIsWeb ? FirebaseWebApi().initNotifications() : FirebaseApi().initNotifications();
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

  }
}
/*
class FirebaseWebApi{
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    final FCMToken;
    FCMToken = await _firebaseMessaging.getToken();
    logger.i('FirebaseWebApi Token : ${FCMToken}');
  }
}
 */