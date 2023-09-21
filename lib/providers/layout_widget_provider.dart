import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter/material.dart';

class LayoutWidgetProvider{

  int _layoutPage = 0;
  int _page = 0;

  // ==============================================
  // 뷰 통지를 위한 콜백 함수
  // ==============================================

  // 위젯에 전달하는 콜백
  void Function() onUpdated = () {};
  void Function(String) onAlert = (msg) {};

  onPageChange(page) async {
    logger.i(page);
    _page = page;
    logger.i(_page);
    onUpdated();
  }


  int getLayoutPage() {
    return _page;
  }

  Future<void>setLayoutPage(int layoutPage) async{
    this._layoutPage = layoutPage;
    //notifyListeners();
  }

}