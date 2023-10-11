import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/resources/auth_methods.dart';
import 'package:flutter_tut/resources/firestore_mehtod.dart';
import 'package:flutter_tut/screen/login_screen.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/custom_circle_avator.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/utils/utils.dart';
import 'package:flutter_tut/widgets/notification_row.dart';

import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;


  int _page = 0;
  @override
  void initState() {
    super.initState();
    getData();

  }

  getData() async{
    setState(() {
      isLoading = true;
    });
    try{
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid).get();



      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(
          FirebaseAuth.instance.currentUser!.uid
      );


    }catch(err){
      showSnackBar(err.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  _pageController(){
    if(_page == 0){
      return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text(
              userData['username'] != null ? userData['username'] : '???ERROR???'
          ),
          actions: [
            /*
            IconButton(
                onPressed: (){
                    setState(() {
                      _page = 1;
                    });
                  },
                icon: Icon(Icons.notification_add)
            ),
            */
            IconButton(
                onPressed: (){
                  showDialog(context: context, builder: (context)=>Dialog(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shrinkWrap: true,
                      children: [
                        '로그아웃'
                      ].map((e) => InkWell(
                          onTap: () async {
                            switch(e){
                              case '로그아웃':
                                await AuthMethods().signOut();
                                Navigator
                                    .of(context)
                                    .pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                                break;
                            }
                            showSnackBar(e, context);
                          },
                          child:Container(
                            padding: const EdgeInsets.symmetric(vertical: 12 , horizontal: 16),
                            child: Text(e),
                          )
                      ),
                      ).toList(),
                    ),
                  ),);
                },
                icon: Icon(Icons.menu)
            ),
          ],
          centerTitle: false,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column( children: [
                Row(
                  children: [
                    CustomCircleAvatar(
                        radius: 40,
                        srcNetworkImage: "1234",
                        srcAssetsImage: defaultUserProfilePath
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postLen , "게시물"),
                              buildStatColumn(followers , "팔로워"),
                              buildStatColumn(following , "팔로잉"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FirebaseAuth.instance.currentUser!.uid == widget.uid ?
                    (
                      Row(
                        children: [
                          FollowButton(
                            text: '프로필 편집',
                            backgroundColor: mobileBackgroundColor,
                            textColor: Colors.white,
                            borderColor: Colors.grey,
                            function: () {},
                          ),
                          FollowButton(
                            text: '알림 설정',
                            backgroundColor: mobileBackgroundColor,
                            textColor: Colors.white,
                            borderColor: Colors.grey,
                            function: () {
                              setState(() {
                                _page = 1;
                              });
                            },
                          )
                        ],
                      )
                    ):(
                        Row(
                          children: [
                            isFollowing ? FollowButton(
                              text: '팔로우 취소',
                              backgroundColor: mobileBackgroundColor,
                              textColor: Colors.white,
                              borderColor: Colors.grey,
                              function: () async {
                                await FirestoreMethod().followUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    userData['uid']
                                );
                                setState(() {
                                  isFollowing = false;
                                  followers--;
                                });
                              },
                            ):FollowButton(
                              text: '팔로우',
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              borderColor: Colors.blue,
                              function: () async {
                                await FirestoreMethod().followUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    userData['uid']
                                );
                                setState(() {
                                  isFollowing = true;
                                  following++;
                                });
                              },
                            ),
                            FollowButton(
                              text: '메세지',
                              backgroundColor: mobileBackgroundColor,
                              textColor: Colors.white,
                              borderColor: Colors.grey,
                              function: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('미구현'),
                                      content: Text('메세지 기능은 아직 미구현 입니다.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('확인'),
                                          onPressed: () {
                                            Navigator.of(context).pop(); // 알림 창 닫기
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        )
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top:15),
                  child: Text(
                    userData['username'] ,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top:1),
                  child: Text(

                    userData['description'] != null ?
                    userData['description']
                        :
                    ''
                    ,
                  ),
                ),
              ],
              ),
            ),
            const Divider(),
            FutureBuilder(
                future: FirebaseFirestore
                    .instance
                    .collection('posts')
                    .where('uid' , isEqualTo: widget.uid)
                    .orderBy('datePublished' , descending: true)
                    .orderBy('postId' , descending: false)
                    .get()
                ,
                builder: (context , snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CircularProgressIndicator(),);
                  }

                  loggerNoStack.e(snapshot);
                  loggerNoStack.e(snapshot.data);
                  final documents = snapshot.data?.docs;
                  return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: documents == null ? 0 : documents.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1.5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1
                      ),
                      itemBuilder: (context , index){
                        DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                        return Container(
                          child: Image(
                            image: NetworkImage(
                                (snap.data()! as dynamic)['postUrl']
                            ),
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                  );

                }),
          ],
        ),
      );
    }else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              setState(() {
                _page = 0;
              });
            },
          ),
          title: const Text('주요 알림 설정'),
          centerTitle: false,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SubscribeRow(notificationKey: 'mainNoti',),
              SubscribeRow(notificationKey: 'newPostNoti',),
              SubscribeRow(notificationKey: 'webDevNoti',),
              SubscribeRow(notificationKey: 'accountNoti',),
              SubscribeRow(notificationKey: 'designNoti',),
              SubscribeRow(notificationKey: 'mdNoti',),

            ],
          )
        )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator(),) :
        _pageController();
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(),
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top:4),
          child: Text(label.toString(),
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      ],
    );
  }

}
