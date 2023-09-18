import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/screen/notification_setting.dart';

import '../screen/add_post_screen.dart';
import '../screen/feed_screen.dart';
import '../screen/profile_screen.dart';
import '../screen/search_screen.dart';

const webScreenSize = 600;
const appLogoSvgPath = 'assets/wow_logo.png';
int appLifecycleState = 2;



bool isComp0Noti = true;
bool isComp1Noti = true;
bool isComp2Noti = true;
bool isComp3Noti = true;


List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  const AppNotificationSettings(),
];