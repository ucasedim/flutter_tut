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
  }

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    initMobileNotification();
    //FlutterLocalNotification.init();

    final userProvider = ref.watch(notiUserProvider);
    final layoutProvider = ref.watch(notiLayoutProvider);

    if(userProvider == null)
      getUser(ref);


    try {
      try {
        /*
        FirebaseMessaging.onBackgroundMessage(handleBackgroundWebMessage);
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          if(ref.read(notiSubscribeProvider.notifier).getSubscribeOption.toMap()['${message.data['notiType']}']!){
            FlutterLocalNotification.showNotification(
              '${message.notification?.title}',
              '${message.notification?.body}',
            );
          }
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
    /*
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
    */
  }

}

/*
class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});
  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  LayoutWidgetProvider lp = LayoutWidgetProvider();
  late SubscribeWidgetProvider _swp = context.read<SubscribeWidgetProvider>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initWebNotification();
    lp.onUpdated = () => setState(() { });
  }

  void navigationTapped(int page){
    lp.getPageController().jumpToPage(page);
  }

  void initWebNotification() async {
    await FirebaseApiInit().init();
  }

  void initFirebaseMessaging(BuildContext context){

    print("firebase init");
    /*
    FirebaseMessaging.onBackgroundMessage(handleBackgroundWebMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        print(
            'Message also contained a notification: ${message.data['notiType']}');
        print(_swp.option.toMap().containsKey('${message.data['notiType']}'));

        if(_swp.option.toMap()['${message.data['notiType']}']!){
          flutterLocalNotificationsPlugin.show(
              1,
              '${message.notification?.title}',
              '${message.notification?.body}',
              null);
        }
        contextPush();
      }
    });
     */
  }


  Future<void> saveToSharedPreferencesAndLocalStorage(String key, String value) async {
    // Saving to shared_preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);

    // Mirroring to localStorage
    //html.window.localStorage[key] = value;
  }

  @override
  Widget build(BuildContext context) {
    print("????????????");
    initFirebaseMessaging(context);
    saveToSharedPreferencesAndLocalStorage('webDevNoti' , 'true');

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

 */