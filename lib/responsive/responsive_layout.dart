import 'package:flutter/material.dart';
import 'package:flutter_tut/responsive/mobile_screen_layout.dart';
import 'package:flutter_tut/responsive/web_screen_layout.dart';
import 'package:flutter_tut/utils/dimensions.dart';

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
  Widget build(BuildContext context) {
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
