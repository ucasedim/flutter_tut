import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    getUsername();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
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
