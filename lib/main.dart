import 'package:flutter_tut/log/test_logger.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: 'AIzaSyAcWf7-fdnB2LdWBVMocLWsaeSIpA3NEiA',
            appId: '1:949694906192:web:c74d351b841e7e3fd53655',
            messagingSenderId: '949694906192',
            projectId: 'instragram-tutc',
            storageBucket: 'instragram-tutc.appspot.com'
        )
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: mobileBackgroundColor,
          ),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context , snapshot){

              loggerNoStack.i('snapshot.connectionState : ');
              loggerNoStack.i(snapshot.connectionState);
              loggerNoStack.i('ConnectionState.active');
              loggerNoStack.i(ConnectionState.active);

              if(snapshot.connectionState == ConnectionState.active) {

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
