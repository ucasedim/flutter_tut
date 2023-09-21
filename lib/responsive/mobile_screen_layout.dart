import 'package:flutter/cupertino.dart';
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

  int _page = 0;
  late PageController pageController;
  String username = "";

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    getUsername();
    initMobileNotification();
    // 초기화
    FlutterLocalNotification.init();
    //lp.onAlert = (msg) => context.showAlert(msg);
    // 3초 후 권한 요청
    Future.delayed(
        const Duration(seconds: 3),
        FlutterLocalNotification.requestNotificationPermission()
    );

    WidgetsBinding.instance.addObserver(this);
    lp.onUpdated = () => setState((){logger.w("setstate call!!!");});
    lp.onAlert('1234');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("didChangeAppLifecycleState: ${state.index} : ${state}");
    appLifecycleState = state.index==null ? 0 : state.index;
    super.didChangeAppLifecycleState(state);
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
    setState(() {

    });
  }

  void initMobileNotification() async {
    await FirebaseApi().initNotifications();
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

      logger.w(lp.getLayoutPage());
      logger.w(lp.getLayoutPage());
      logger.w(lp.getLayoutPage());
      logger.w(lp.getLayoutPage());
      model.User user = Provider
          .of<UserProvider>(context)
          .getUser;

    return Scaffold(
        body:PageView(
          children: homeScreenItems,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          //onPageChanged: onPageChanged,
          onPageChanged: lp.onPageChange,
        ),
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: mobileBackgroundColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: lp.getLayoutPage() == 0 ? primaryColor : secondaryColor,
              ),
              label: '',
                backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: lp.getLayoutPage() == 1 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: lp.getLayoutPage() == 2 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: lp.getLayoutPage() == 3 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: lp.getLayoutPage() == 4 ? primaryColor : secondaryColor,
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
