import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/utils/global_variables.dart';
//import 'package:http/http.dart';

int exceptionRetryCnt = 0;

void contextPush(){


}
Future<void> handleBackgroundWebMessage(RemoteMessage message)  async{
  logger.e('Title : ${message.notification?.title}');
  logger.e('Body : ${message.notification?.body}');
  logger.e('Payload : ${message.data}');
}

class FirebaseWebApi{

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Future<void> initNotifications() async {
    try {
      //await _firebaseMessaging.requestPermission();
      final FCMToken;
      FCMToken = await _firebaseMessaging.getToken();
      print(FCMToken);
      print(FCMToken);
      print(FCMToken);
      logger.e('Token : $FCMToken');

      //var url = Uri.https(fcmServerPutTokenUrl, 'application/json');
      var url = Uri.parse(fcmServerPutTokenUrl);
      Map<String,String> headerInfo = {'Content-Type':'application/json'};
      var reqBody = jsonEncode({'token': FCMToken, 'uid':'' , 'platform':'web'});
      print("call url ${url}");

      /*
      var response = await post(
        url,
        headers: headerInfo,
        body: reqBody,
      );
*/
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

          contextPush();
        }
      });
      FirebaseMessaging.onBackgroundMessage(handleBackgroundWebMessage);

    }catch(e){
      if(exceptionRetryCnt < 10) {
        //Restart.restartApp();
        print(e.toString());
        logger.e(e.toString());
        logger.w('FirebaseWebApi().initNotifications() retry' + exceptionRetryCnt.toString());
        FirebaseWebApi().initNotifications();
        exceptionRetryCnt++;
      }
    }
  }

}