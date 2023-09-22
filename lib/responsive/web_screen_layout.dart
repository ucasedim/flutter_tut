import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tut/api/firebase_api.dart';
import 'package:flutter_tut/api/firebase_web_api.dart';
import 'package:flutter_tut/providers/layout_widget_provider.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:provider/provider.dart';

import '../log/test_logger.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});
  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  LayoutWidgetProvider lp = LayoutWidgetProvider();
  @override
  void initState() {
    super.initState();
    //getUsername();
    initWebNotification();
    lp.onUpdated = () => setState(() { });
    /* webtoken */
    //getPermission();
    //messageListener(context);
  }

  void navigationTapped(int page){
    lp.getPageController().jumpToPage(page);
  }

  void initWebNotification() async {
    await FirebaseApiInit().init();
  }

  @override
  Widget build(BuildContext context) {

    //final page = context.watch<LayoutWidgetProvider>().getPage();

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