import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tut/api/firebase_api.dart';
import 'package:flutter_tut/api/firebase_web_api.dart';
import 'package:flutter_tut/providers/layout_widget_provider.dart';
import 'package:flutter_tut/providers/subscribe_widget_provider.dart';
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebScreenLayout extends ConsumerWidget{

  var lp = null;
  var _swp = null;

  void navigationTapped(int page){
    lp.getPageController().jumpToPage(page);
  }

  void initWebNotification() async {
    await FirebaseApiInit().init();
  }

  void initFirebaseMessaging(BuildContext context){

    print("firebase init");
    /*
    FirebaseMessaging.onBackgroundMessage(handleBackgroundWebMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print(
            'Message also contained a notification: ${message.data['notiType']}');
        print(_swp.option.toMap().containsKey('${message.data['notiType']}'));

        if(_swp.option.toMap()['${message.data['notiType']}']!){
          flutterLocalNotificationsPlugin.show(
              1,
              '${message.notification?.title}',
              '${message.notification?.body}',
              null);
        }
        contextPush();
      }
    });
     */
  }


  Future<void> saveToSharedPreferencesAndLocalStorage(String key, String value) async {
    // Saving to shared_preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);

    // Mirroring to localStorage
    //html.window.localStorage[key] = value;
  }

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    print("????????????");
    initFirebaseMessaging(context);
    saveToSharedPreferencesAndLocalStorage('webDevNoti' , 'true');
    lp = ref.watch(layoutWidgetProcessProvider);
    //_swp = ref.watch(subscribeWidgetProcessProvider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset(
            'assets/ic_wow_logo.svg',
            color: primaryColor,
            height: 32,
          ),
          actions: [
            IconButton(
              onPressed: ()=>navigationTapped(0),
              icon: Icon(Icons.home , color: lp.getPage() == 0? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(1),
              icon: Icon(Icons.search, color: lp.getPage() == 1? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(2),
              icon: Icon(Icons.add_a_photo, color: lp.getPage() == 2? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(3),
              icon: Icon(Icons.favorite, color: lp.getPage() == 3? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(4),
              icon: Icon(Icons.person, color: lp.getPage() == 4? primaryColor : secondaryColor),
            ),
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: homeScreenItems,
          controller: lp.getPageController(),
          onPageChanged: lp.setPage,
        )
    );

  }

}

/*
class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});
  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  LayoutWidgetProvider lp = LayoutWidgetProvider();
  late SubscribeWidgetProvider _swp = context.read<SubscribeWidgetProvider>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initWebNotification();
    lp.onUpdated = () => setState(() { });
  }

  void navigationTapped(int page){
    lp.getPageController().jumpToPage(page);
  }

  void initWebNotification() async {
    await FirebaseApiInit().init();
  }

  void initFirebaseMessaging(BuildContext context){

    print("firebase init");
    /*
    FirebaseMessaging.onBackgroundMessage(handleBackgroundWebMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print(
            'Message also contained a notification: ${message.data['notiType']}');
        print(_swp.option.toMap().containsKey('${message.data['notiType']}'));

        if(_swp.option.toMap()['${message.data['notiType']}']!){
          flutterLocalNotificationsPlugin.show(
              1,
              '${message.notification?.title}',
              '${message.notification?.body}',
              null);
        }
        contextPush();
      }
    });
     */
  }


  Future<void> saveToSharedPreferencesAndLocalStorage(String key, String value) async {
    // Saving to shared_preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);

    // Mirroring to localStorage
    //html.window.localStorage[key] = value;
  }

  @override
  Widget build(BuildContext context) {
    print("????????????");
    initFirebaseMessaging(context);
    saveToSharedPreferencesAndLocalStorage('webDevNoti' , 'true');

    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: SvgPicture.asset(
            'assets/ic_wow_logo.svg',
            color: primaryColor,
            height: 32,
          ),
          actions: [
            IconButton(
              onPressed: ()=>navigationTapped(0),
              icon: Icon(Icons.home , color: lp.getPage() == 0? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(1),
              icon: Icon(Icons.search, color: lp.getPage() == 1? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(2),
              icon: Icon(Icons.add_a_photo, color: lp.getPage() == 2? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(3),
              icon: Icon(Icons.favorite, color: lp.getPage() == 3? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(4),
              icon: Icon(Icons.person, color: lp.getPage() == 4? primaryColor : secondaryColor),
            ),
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: homeScreenItems,
          controller: lp.getPageController(),
          onPageChanged: lp.setPage,
        )
    );

  }
}

 */