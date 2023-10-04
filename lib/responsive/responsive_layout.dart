import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/api/firebase_api.dart';
import 'package:flutter_tut/providers/layout_widget_provider.dart';
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:flutter_tut/responsive/mobile_screen_layout.dart';
import 'package:flutter_tut/responsive/web_screen_layout.dart';
import 'package:flutter_tut/utils/global_variables.dart';


class ResponsiveLayout extends ConsumerWidget{
  /*
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout})
      : super(key: key);
  */
  addData() async{
    //UserProvider _userProvider = Provider.of(context , listen: false);
    //await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    addData();
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          return WebScreenLayout();
        }
        return MobileScreenLayout();
        //mobileScreen
      },
    );
  }

}

/*
class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;

  const ResponsiveLayout({Key? key,
    required this.webScreenLayout,
    required this.mobileScreenLayout})
      : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayout();

}

class _ResponsiveLayout extends State<ResponsiveLayout>{

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async{
    UserProvider _userProvider = Provider.of(context , listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > webScreenSize) {
            return const WebScreenLayout();
          }
          return const MobileScreenLayout();
          //mobileScreen
        },
      );
  }
}
*/