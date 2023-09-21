import 'package:flutter_tut/log/test_logger.dart';

import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/resources/auth_methods.dart';


class LayoutWidgetProvider with ChangeNotifier{
  int _layoutPage = 0;

  int getLayoutPage() {
    return this._layoutPage;
  }

  Future<void>setLayoutPage(int layoutPage) async{
    this._layoutPage = layoutPage;
    notifyListeners();
  }

}