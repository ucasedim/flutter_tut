import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/api/firebase_api.dart';
import 'package:flutter_tut/model/SubscribeOption.dart';
import 'package:flutter_tut/resources/auth_methods.dart';
import 'package:flutter_tut/resources/firestore_mehtod.dart';
import 'package:flutter_tut/utils/global_variables.dart';

class SubscribeWidgetProvider extends StateNotifier<SubscribeOption?> {

  SubscribeWidgetProvider(super.state);
  SubscribeOption? option;
  SubscribeOption get getSubscribeOption => option!;


  Future<void> setSubscribeOptionFromFirebase() async {
    SubscribeOption? so = await AuthMethods().getSubscribeOption();
    option = so;
    globalSubscribeOption = (option ??
                              SubscribeOption(
                                mainNoti: true,
                                newPostNoti: false,
                                webDevNoti: false,
                                accountNoti: false,
                                designNoti: false,
                                mdNoti: false
                              ))!;

    so ??
      globalSubscribeOption!.toMap().forEach((key, value) {
        if(value){
          FirebaseApi().subscribeToTopic(key);
        }else{
          FirebaseApi().unsubscribeToTopic(key);
        }
      });
  }

  Future<void> setSubscribeOptionFromSnapshot(DocumentSnapshot snap) async {
    option = SubscribeOption(
        mainNoti   : snap['mainNoti'],
        newPostNoti: snap['newPostNoti'],
        webDevNoti : snap['webDevNoti'],
        accountNoti: snap['accountNoti'],
        designNoti : snap['designNoti'],
        mdNoti     : snap['mdNoti']
    );
  }

  Future<void> setSubscribeOptionFromMap( Map<String,bool>? map)  async {
    map == null ?
    option = null
    :option = SubscribeOption(
        mainNoti   : map['mainNoti']!,
        newPostNoti: map['newPostNoti']!,
        webDevNoti : map['webDevNoti']!,
        accountNoti: map['accountNoti']!,
        designNoti : map['designNoti']!,
        mdNoti     : map['mdNoti']!
    );
  }

  bool getSubscribeOptionKey(String key){
    return option?.toMap()[key] ?? false;
  }

  void setSubscribeOption(String key , bool value , String uid) async {
    Map<String, bool> _map = option!.toMap();
    _map.remove(key);
    _map[key] = value;
    await setSubscribeOptionFromMap(_map);
    await FirestoreMethod().updateNotification(uid, option!.toMap());
  }

  String getKeyName(String key){
    return option!.getKeyName(key);
  }

}