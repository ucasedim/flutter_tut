import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter/material.dart';

class LayoutWidgetProvider with ChangeNotifier {

  int _page = 0;
  String _name = "";
  PageController _pageController = PageController();

  // 위젯에 전달하는 콜백
  void Function() onUpdated = () {};

  Future<void> setPage(int page) async {
    _page = page;
    onUpdated();
  }

  Future<void> setName(String name) async{
    _name = name;
    onUpdated();
  }

  int getPage() {
    return _page == null ? 0 : _page;
  }

  String getName(){
    return _name == null ? '사용자 정보 오류' : _name;
  }

  PageController getPageController(){
    return _pageController;
  }

}