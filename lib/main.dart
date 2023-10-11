import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_tut/firebase_options.dart';
import 'package:flutter_tut/responsive/responsive_layout.dart';
import 'package:flutter_tut/screen/login_screen.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    logger.i("app is Web Start");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );
  } else {
    logger.i("app is not Web Start");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: true,
          title: '와우프레스 알림이',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context , snapshot){
              if(snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return ResponsiveLayout(
                      //mobileScreenLayout: MobileScreenLayout(),
                      //webScreenLayout: WebScreenLayout(),
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
        );
  }
}
