import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/model/layout.dart';

class LayoutProvider extends StateNotifier<Layout?> {
  LayoutProvider(super.state);
  Layout? layout;
  Layout? get getLayout => layout;
}