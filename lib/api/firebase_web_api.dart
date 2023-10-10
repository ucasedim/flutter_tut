import 'dart:convert';
import 'package:http/http.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/utils/global_variables.dart';

int exceptionRetryCnt = 0;
Future<void> handleBackgroundWebMessage(RemoteMessage message)  async{
  logger.e('Title : ${message.notification?.title}');
  logger.e('Body : ${message.notification?.body}');
  logger.e('Payload : ${message.data}');
}

class FirebaseWebApi{
  //final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Future<void> initNotifications() async {
    try {
      _requestPermission();
      _getToken();
      _listenForMessages();

      //print('_firebaseMessaging');
      //print(_firebaseMessaging);
      //final FCMToken;
      //FCMToken = await _firebaseMessaging.getToken();

      //await _firebaseMessaging.requestPermission();
      //print(FCMToken);
      /*
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
*/

    }catch(e){
      if(exceptionRetryCnt < 10) {
        //Restart.restartApp();
        print(e.toString());
        logger.e(e.toString());
        logger.w('FirebaseWebApi().initNotifications() retry web' + exceptionRetryCnt.toString());
        FirebaseWebApi().initNotifications();
        exceptionRetryCnt++;
      }
    }
  }


  _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  _getToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('Token: $token');
    var url = Uri.parse(fcmServerPutTokenUrl);
    Map<String,String> headerInfo = {'Content-Type':'application/json'};
    var reqBody = jsonEncode({'token': token, 'uid':'' , 'platform':'web'});
    print("call url ${url}");

    var response = await post(
      url,
      headers: headerInfo,
      body: reqBody,
    );

  }

  _listenForMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message: ${message.data}');
    });
  }

}