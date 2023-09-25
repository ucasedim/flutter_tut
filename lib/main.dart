import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/providers/layout_widget_provider.dart';
import 'package:flutter_tut/providers/subscribe_widget_provider.dart';
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_tut/firebase_options.dart';
import 'package:flutter_tut/responsive/mobile_screen_layout.dart';
import 'package:flutter_tut/responsive/responsive_layout.dart';
import 'package:flutter_tut/responsive/web_screen_layout.dart';
import 'package:flutter_tut/screen/login_screen.dart';
import 'package:flutter_tut/screen/signup_screen.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'api/firebase_api.dart';
import 'api/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    logger.i("app is Web Start");
    await Firebase.initializeApp(
      name: 'wow-noti-web',
      options: DefaultFirebaseOptions.web,
    );
    //await FirebaseWebApi().initNotifications();
  } else {
    logger.i("app is not Web Start");
    await Firebase.initializeApp(
       name: 'wow-noti-mobile',
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //await FirebaseApi().initNotifications();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => LayoutWidgetProvider(),
          ),
          ChangeNotifierProvider(
              create: (_) => SubscribeWidgetProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: true,
          title: 'wowpress noti',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context , snapshot){
              if(snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                      mobileScreenLayout: MobileScreenLayout(),
                      webScreenLayout: WebScreenLayout(),
                    );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }

              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }

              return const LoginScreen();

            },
          ),
        )
      );
  }
}
