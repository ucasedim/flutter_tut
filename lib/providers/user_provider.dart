import '../model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/resources/auth_methods.dart';


class UserProvider with ChangeNotifier{
  User? _user;
  final AuthMethods _autoMethod = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async{
    User user = await _autoMethod.getUserDetails();
    _user = user;
    notifyListeners();
  }
}