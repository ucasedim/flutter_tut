import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tut/api/firebase_web_api.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/providers/layout_widget_provider.dart';
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:flutter_tut/utils/global_variables.dart';
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
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import 'api/firebase_api.dart';
import 'api/notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    logger.i('Platform Web Start');
    await Firebase.initializeApp(options: DefaultFirebaseOptions.web,);
    logger.w('Firebase init End');
    //await FirebaseWebApi().initNotifications();
    logger.i('Firebase Noti End');
  } else {
    logger.w('kIsElse Context Start');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //await FirebaseApi().initNotifications();
  }

  try {
    runApp(const MyApp());
  }catch(e){
    logger.i(e.toString());
  }
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
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: naviagatorState,
            title: '와우프레스 알림이',
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: mobileBackgroundColor,
            ),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                //loggerNoStack.i('snapshot.connectionState : ');
                //loggerNoStack.i(snapshot.connectionState);
                //loggerNoStack.i('ConnectionState.active');
                //loggerNoStack.i(ConnectionState.active);
                if (snapshot.connectionState == ConnectionState.active) {
                  loggerNoStack.i('snapshot.hasData');
                  loggerNoStack.i(snapshot.hasData);

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

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  );
                }

                return const LoginScreen();
              },
            ),
            //LoginScreen(),

            /*
          ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          )
          */

          )
      );
  }
}
