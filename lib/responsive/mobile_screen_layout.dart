import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tut/api/firebase_api.dart';
import 'package:flutter_tut/providers/layout_widget_provider.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/utils/utils.dart';

import '../api/notification.dart';
import '../model/user.dart' as model;
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);
  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout>
    with WidgetsBindingObserver {

  LayoutWidgetProvider lp = LayoutWidgetProvider();
  @override
  void initState() {
    logger.e("mobile screen call");
    super.initState();
    initMobileNotification();
    FlutterLocalNotification.init();
    // 3초 후 권한 요청
    Future.delayed(
        const Duration(seconds: 3),
        FlutterLocalNotification.requestNotificationPermission()
    );

    //WidgetsBinding.instance.addObserver(this);
    lp.onUpdated = () => setState((){logger.w("setstate call!!! mobile layout");});
  }

  void navigationTapped(int page){
    lp.getPageController().jumpToPage(page);
  }

  void initMobileNotification() async {
    await FirebaseApiInit().init();
  }
/*
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("didChangeAppLifecycleState: ${state.index} : ${state}");
    appLifecycleState = state.index==null ? 0 : state.index;
    super.didChangeAppLifecycleState(state);
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
*/

  @override
  Widget build(BuildContext context) {
    try {
      /*
      model.User user = Provider
          .of<UserProvider>(context)
          .getUser;
      */
    }catch(e){
      loggerNoStack.e("mobile_screen_layout.dart");
      logger.e(e.toString());
    }

    return Scaffold(
        body:PageView(
          children: homeScreenItems,
          physics: const NeverScrollableScrollPhysics(),
          controller: lp.getPageController(),
          onPageChanged: lp.setPage,
          //setPaged: lp.setPage,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: lp.getPage() == 0 ? primaryColor : secondaryColor,
              ),
              label: '',
                backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: lp.getPage() == 1 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: lp.getPage() == 2 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: lp.getPage() == 3 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: lp.getPage() == 4 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
          ],
          onTap: navigationTapped,
        ),
      );
  }
}
