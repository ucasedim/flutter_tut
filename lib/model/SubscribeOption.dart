
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class SubscribeOption {

  bool mainNoti = true;
  bool newPostNoti = false;
  bool webDevNoti = false;
  bool accountNoti = false;
  bool designNoti = false;
  bool mdNoti = false;

  // 위젯에 전달하는 콜백
  void Function() onUpdated = () {};

  Map<String,String> keyName = {
    'mainNoti' : '메인 공지사항',
    'newPostNoti' : '새글알림',
    'webDevNoti' : '전산팀 알림',
    'accountNoti' : '경리팀 알림',
    'designNoti' : '디자인팀 알림',
    'mdNoti' : 'MD팀 알림',
  };

  String getKeyName(String key)  {
    return keyName[key]!;
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

  void saveFromMapData( Map<String, bool> map) {

    print("?? :  ${map['newPostNoti']}");
         this.mainNoti    = map['mainNoti']!;
         this.newPostNoti = map['newPostNoti']!;
         this.webDevNoti  = map['webDevNoti']!;
         this.accountNoti = map['accountNoti']!;
         this.designNoti  = map['designNoti']!;
         this.mdNoti      = map['mdNoti']!;
  }


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