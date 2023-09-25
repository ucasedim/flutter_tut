import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/model/SubscribeOption.dart';
import 'package:flutter_tut/model/user.dart';
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:flutter_tut/resources/auth_methods.dart';
import 'package:flutter_tut/resources/firestore_mehtod.dart';

class SubscribeWidgetProvider with ChangeNotifier {

  SubscribeOption option = SubscribeOption();
  // 위젯에 전달하는 콜백
  void Function() onUpdated = () {};

  Future<void> setSubscribeOptionFromSnapshot(DocumentSnapshot snap) async {
    option.mainNoti = snap['mainNoti'];
    option.webDevNoti = snap['webDevNoti'];
    option.accountNoti = snap['accountNoti'];
    option.designNoti = snap['designNoti'];
    option.mdNoti = snap['mdNoti'];
  }

  Future<void> setSubscribeOptionFromMap( Map<String,bool> map)  async {
    option.mainNoti = map['mainNoti']!;
    option.webDevNoti = map['webDevNoti']!;
    option.accountNoti = map['accountNoti']!;
    option.designNoti = map['designNoti']!;
    option.mdNoti = map['mdNoti']!;
  }

  bool getSubscribeOption(String key){
    return option.toMap()[key] ?? false;
  }

  void setSubscribeOption(String key , bool value , String uid){
    print("setSubscribeOption 1 : ${key} , ${value}");
    Map<String,bool> _map = option.toMap();
    _map.remove(key);
    _map[key] = value;
    option.saveFromMapData(_map);
    print("map 2 :  ${option.toMap()}");
    print("setSubscribeOption 3: ${getSubscribeOption(key)}");
    notifyListeners();




    FirestoreMethod().updateNotification(uid, option.toMap());

  }

  String getKeyName(String key){
    return option.getKeyName(key);
  }

}