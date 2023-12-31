import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/utils/colors.dart';
class AppNotificationSettings extends StatefulWidget {
  const AppNotificationSettings({super.key});

  @override
  State<AppNotificationSettings> createState() => _AppNotificationSettingsState();
}

class _AppNotificationSettingsState extends State<AppNotificationSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {

          },
        ),
        title: const Text('주요 알림 설정'),
        centerTitle: false,
      ),
      body: Center(
          child: Text('body'),
      ),
    );
  }
}
