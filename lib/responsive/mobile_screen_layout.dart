import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/api/firebase_api.dart';
import 'package:flutter_tut/model/layout.dart';
import 'package:flutter_tut/providers/layout_widget_provider.dart';
import 'package:flutter_tut/providers/subscribe_widget_provider.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/utils/utils.dart';

import '../api/notification.dart';
import '../model/user.dart' as model;
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MobileScreenLayout extends ConsumerWidget{

  void initMobileNotification() async {
    await FirebaseApiInit().init();
  }

  @override
  Widget build(BuildContext context , WidgetRef ref) {

    initMobileNotification();
    FlutterLocalNotification.init();

    final userProvider = ref.watch(userInfoProcessProvider);
    final layoutProvider = ref.watch(layoutWidgetProcessProvider);
    final subscribeProvider = ref.watch(subscribeWidgetProcessProvider);

    try {

      try {
        FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          logger.i("onMessage!!Lissten ${message.notification?.title}");
          loggerNoStack.i('${message.data['notiType']}');
          loggerNoStack.i(subscribeProvider.option.toMap()['${message.data['notiType']}']);
          if(subscribeProvider.option.toMap()['${message.data['notiType']}']!){
            FlutterLocalNotification.showNotification(
              '${message.notification?.title}',
              '${message.notification?.body}',
            );
          }
        });
      }catch(e){
        loggerNoStack.e('firebase_api.dart FirebaseApi MessageException');
        logger.e(e.toString());
      }

    }catch(e){
      loggerNoStack.e("mobile_screen_layout.dart");
      logger.e(e.toString());
    }

    void layoutProvSetPage(int page){
      final currentModel = layoutProvider;
      final updatedModel = Layout(
        pageController: currentModel.pageController,
        page: page,
        name: currentModel.name,
        file: currentModel.file,
      );
      ref.read(layoutWidgetProcessProvider.notifier).state = updatedModel;
    }

    return Scaffold(
      body:PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: layoutProvider.pageController,
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