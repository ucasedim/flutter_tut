import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/screen/add_post_screen.dart';
import 'package:flutter_tut/screen/feed_screen.dart';
import 'package:flutter_tut/screen/notification_setting.dart';
import 'package:flutter_tut/screen/profile_screen.dart';
import 'package:flutter_tut/screen/search_screen.dart';

const webScreenSize = 600;
const appLogoSvgPath = 'assets/wow_logo.png';
int appLifecycleState = 2;
bool isComp0Noti = true;
bool isComp1Noti = true;
bool isComp2Noti = true;
bool isComp3Noti = true;

const fcmServerPutTokenUrl = "http://192.168.30.140:8080/api/v1/tokenmanage/put";

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

final GlobalKey<NavigatorState> naviagatorState = GlobalKey<NavigatorState>();
