import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/model/layout.dart';
import 'package:flutter_tut/model/user.dart';
import 'package:flutter_tut/resources/auth_methods.dart';
import 'package:flutter_tut/utils/global_variables.dart';


class LayoutProvider extends StateNotifier<Layout?> {

  LayoutProvider(super.state);

  Layout? layout;
  Layout? get getLayout => layout;

  /*
  Future<void> refreshUser() async {
    User user = await _autoMethod.getUserDetails();
    _user = user;
  }
  */
}