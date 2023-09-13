import 'package:flutter/cupertino.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/utils/utils.dart';

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

class _MobileScreenLayoutState extends State<MobileScreenLayout>{
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
    try {
      model.User user = Provider
          .of<UserProvider>(context)
          .getUser;
    } catch(e){
      showSnackBar(e.toString(), context);
    }
    return Scaffold(
      body:PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            label: '',
              backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? primaryColor : secondaryColor,
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
