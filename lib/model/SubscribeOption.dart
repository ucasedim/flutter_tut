
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class SubscribeOption {

  final bool mainNoti;
  final bool newPostNoti;
  final bool webDevNoti;
  final bool accountNoti;
  final bool designNoti;
  final bool mdNoti;

  SubscribeOption({
    required this.mainNoti,
    required this.newPostNoti,
    required this.webDevNoti,
    required this.accountNoti,
    required this.designNoti,
    required this.mdNoti
  });

  Map<String,String> keyName = {
    'mainNoti' : '메인 공지사항',
    'newPostNoti' : '새글알림',
    'webDevNoti' : '전산팀 알림',
    'accountNoti' : '경리팀 알림',
    'designNoti' : '디자인팀 알림',
    'mdNoti' : 'MD팀 알림',
  };

  String getKeyName(String key)  {
    String returnValue = 'errorvalue';
    if(key.contains(key))
      returnValue = keyName[key]!;

    return returnValue;
  }

/*
  setSubscribeOption(String key , bool value){
    toMap()[key] = value!;
  }
*/

  Map<String,bool> toJson() =>{
    "mainNoti" : mainNoti,
    "newPostNoti" : newPostNoti,
    "webDevNoti" : webDevNoti,
    "accountNoti" : accountNoti,
    "designNoti" : designNoti,
    "mdNoti" : mdNoti,
  };

  Map<String,bool> toMap()=>{
    "mainNoti" : mainNoti,
    "newPostNoti" : newPostNoti,
    "webDevNoti" : webDevNoti,
    "accountNoti" : accountNoti,
    "designNoti" : designNoti,
    "mdNoti" : mdNoti,
  };

/*
  static SubscribeOption fromSnapshot( DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String,dynamic>;
     return SubscribeOption(
         mainNoti   : snapshot['snapmainNoti'],
         webDevNoti : snapshot['webDevNoti'],
         accountNoti: snapshot['accountNoti'],
         designNoti : snapshot['designNoti'],
         mdNoti     : snapshot['mdNot'],
     );
  }
*/

}