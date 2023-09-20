import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tut/api/firebase_web_api.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';

import '../log/test_logger.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {

  int _page = 0;
  late PageController pageController;
  String username = "";

  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    getUsername();
    initWebNotification();
    /* webtoken */
    //getPermission();
    //messageListener(context);
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void initWebNotification() async {
    await FirebaseWebApi().initNotifications();
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid).get();

    setState(() {
      username = (snap.data() as Map<String,dynamic>)['username'];
    });
  }

  void onPageChanged(int page){
    logger.w(_page);
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              icon: Icon(Icons.home , color: _page == 0? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(1),
              icon: Icon(Icons.search, color: _page == 1? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(2),
              icon: Icon(Icons.add_a_photo, color: _page == 2? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(3),
              icon: Icon(Icons.favorite, color: _page == 3? primaryColor : secondaryColor),
            ),
            IconButton(
              onPressed: ()=>navigationTapped(4),
              icon: Icon(Icons.person, color: _page == 4? primaryColor : secondaryColor),
            ),
          ],
        ),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          children: homeScreenItems,
          controller: pageController,
          onPageChanged: onPageChanged,
        )
    );

  }
}


//push notification dialog for foreground
class DynamicDialog extends StatefulWidget {
  final title;
  final body;
  DynamicDialog({this.title, this.body});
  @override
  _DynamicDialogState createState() => _DynamicDialogState();
}

class _DynamicDialogState extends State<DynamicDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: <Widget>[
        OutlinedButton.icon(
            label: Text('Close'),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close))
      ],
      content: Text(widget.body),
    );
  }
}


Future<void> getPermission() async {
  try {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }catch(e){
    logger.e(e.toString());
  }
}

void messageListener(BuildContext context) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    print('zzzzzzzzzzzzzz');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification?.body}');
      showDialog(
          context: context,
          builder: ((BuildContext context) {
            return DynamicDialog(
                title: message.notification?.title,
                body: message.notification?.body);
          }));
    }
  });
}


