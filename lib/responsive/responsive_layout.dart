import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/responsive/mobile_screen_layout.dart';
import 'package:flutter_tut/responsive/web_screen_layout.dart';
import 'package:flutter_tut/utils/global_variables.dart';

class ResponsiveLayout extends ConsumerWidget{
  const ResponsiveLayout({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
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