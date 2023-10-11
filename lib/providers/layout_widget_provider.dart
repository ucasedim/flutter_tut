import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/model/layout.dart';

class LayoutWidgetProvider extends StateProvider<Layout?>{

  LayoutWidgetProvider(super.createFn);
  Layout? _layout;

  void setPage(int page) {
    _layout?.fromToJson(_layout?.toJson().update('page', (value) => page));
  }

}