import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/model/SubscribeOption.dart';
import 'package:flutter_tut/model/add_post.dart';
import 'package:flutter_tut/model/layout.dart';
import 'package:flutter_tut/model/post_card_info.dart';
import 'package:flutter_tut/model/user.dart' as model;
import 'package:flutter_tut/providers/layout_provider.dart';
import 'package:flutter_tut/providers/layout_widget_provider.dart';
import 'package:flutter_tut/providers/post_card_provider.dart';
import 'package:flutter_tut/providers/post_file_provider.dart';
import 'package:flutter_tut/providers/subscribe_widget_provider.dart';
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:flutter_tut/resources/auth_methods.dart';
import 'package:flutter_tut/screen/add_post_screen.dart';
import 'package:flutter_tut/screen/feed_screen.dart';
import 'package:flutter_tut/screen/notification_setting.dart';
import 'package:flutter_tut/screen/profile_screen.dart';
import 'package:flutter_tut/screen/search_screen.dart';

/*
 * 앱관련 기본 설정값
 * 테스트 데이터 포함
 */
const webScreenSize = 600;
const appLogoSvgPath = 'assets/wow_logo.png';
const fcmServerPutTokenUrl = "http://192.168.30.140:8080/api/v1/tokenmanage/put";
const defaultUserProfilePath = 'assets/free-icon-user-avatar-6596121.png';


/*
 * 프로바이더 관련 설정
 * notiAddPostProcessProvider : Firebase 관련 설정
 *  : 메인 AppScreen 관련
 *  : 알림 관련 Provider
 */
final notiAddPostProvider =StateNotifierProvider<AddPostProvider , AddPost?>((ref) => AddPostProvider(null));
final notiUserProvider = StateNotifierProvider<UserProvider, model.User?>((ref) => UserProvider(null));
final notiSubscribeProvider = StateNotifierProvider<SubscribeWidgetProvider, SubscribeOption?>((ref) => SubscribeWidgetProvider(null));
final notiLayoutProvider = StateNotifierProvider<LayoutProvider , Layout?>((ref) => LayoutProvider(
    Layout(file: null, name: '', page: 0, pageController: PageController())
));
final notiPostCardInfoProvider = StateNotifierProvider<PostCardProvider , PostCardInfo?>((ref) => PostCardProvider(
    PostCardInfo(isLikeAnimating: false)
));

/*
* 메인페이지에서 사용하는 화면 리스트
* Change 값에 따라 화면 호출
*/
List<Widget> homeScreenItems = [
  FeedScreen(),
  const SearchScreen(),
  AddPostScreen(),
  const Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  const AppNotificationSettings(),
];

/* *
* 라이프사이클 상태를 볼려고 선언했는데 지금은 안씀
* */
final GlobalKey<NavigatorState> naviagatorState = GlobalKey<NavigatorState>();
int appLifecycleState = 2;



bool isComp0Noti = true;
bool isComp1Noti = true;
bool isComp2Noti = true;
bool isComp3Noti = true;

SubscribeOption? globalSubscribeOption;