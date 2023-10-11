import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/api/firebase_api.dart';
import 'package:flutter_tut/api/firebase_web_api.dart';
import 'package:flutter_tut/api/notification.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/model/layout.dart';
import 'package:flutter_tut/resources/auth_methods.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';

class WebScreenLayout extends ConsumerWidget{

  void initMobileNotification() async {
    await FirebaseWebApi().initNotifications();
  }

  getUser(WidgetRef ref) async{
    ref.read(notiUserProvider.notifier).state = await AuthMethods().getUserDetails();
    await ref.read(notiSubscribeProvider.notifier).setSubscribeOptionFromFirebase();
  }

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    initMobileNotification();
    //FlutterLocalNotification.init();

    final userProvider = ref.watch(notiUserProvider);
    final layoutProvider = ref.watch(notiLayoutProvider);

    if(userProvider == null) {
      getUser(ref);
    }

    try {
      try {
        /*
        FirebaseMessaging.onBackgroundMessage(handleBackgroundWebMessage);
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          //if(ref.read(notiSubscribeProvider.notifier).getSubscribeOption.toMap()['${message.data['notiType']}']!){
            FlutterLocalNotification.showNotification(
              '${message.notification?.title}',
              '${message.notification?.body}',
            );
          //}
        });
         */
      }catch(e){
        loggerNoStack.e('firebase_api.dart FirebaseApi MessageException');
        logger.e(e.toString());
      }
    }catch(e){
      loggerNoStack.e("mobile_screen_layout.dart");
      logger.e(e.toString());
    }

    void layoutProvSetPage(int page){
      final updateModel = Layout(
        pageController: layoutProvider!.pageController,
        page: page,
        name: layoutProvider!.name,
        file: layoutProvider?.file,
      );
      ref.read(notiLayoutProvider.notifier).state = updateModel;
    }
    return Scaffold(
      body:PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: layoutProvider!.pageController,
        onPageChanged: layoutProvSetPage,
        //setPaged: layoutProvider.setPage,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: layoutProvider.page == 0 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: layoutProvider.page == 1 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: layoutProvider.page == 2 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: layoutProvider.page == 3 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: layoutProvider.page == 4 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: layoutProvider.navigationTapped,
      ),
    );
  }
}