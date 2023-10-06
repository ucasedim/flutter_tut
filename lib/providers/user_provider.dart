import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/model/user.dart';
import 'package:flutter_tut/resources/auth_methods.dart';
import 'package:flutter_tut/utils/global_variables.dart';


class UserProvider extends StateNotifier<User?> {

  //UserProvider(super.createFn);
  //UserProvider() : super(super.createFn);
  UserProvider(super.state);
  User? _user;
  final AuthMethods _autoMethod = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await _autoMethod.getUserDetails();
    _user = user;
  }

}