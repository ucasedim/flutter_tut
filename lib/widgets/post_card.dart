import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/model/post_card_info.dart';
import 'package:flutter_tut/providers/layout_widget_provider.dart';
import 'package:flutter_tut/resources/firestore_mehtod.dart';
import 'package:flutter_tut/screen/comment_screeen.dart';
import 'package:flutter_tut/screen/profile_screen.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/custom_circle_avator.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/utils/utils.dart';
import 'package:flutter_tut/widgets/like_animations.dart';
import 'package:intl/intl.dart';

import '../model/user.dart';

class PostCard extends ConsumerWidget{

  final snap;

  PostCard({
    required this.snap
  });



  @override
  Widget build(BuildContext context , WidgetRef ref) {


    Future<int> getComments() async{
      QuerySnapshot _snap = await FirebaseFirestore.instance.collection('posts')
          .doc(snap['postId']).collection('comments')
          .get();

      print("???????????????????????????????????????????????????????????????????");
      print("${_snap.docs.length}");

      return _snap.docs.length;
    }

    bool isLikeAnimating = false;

    final userProvider = ref.watch(notiUserProvider);
    final postCardInfo = ref.watch(notiPostCardInfoProvider);
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical:10,
      ),
      child: Column(
        children: [
          Container(
            //Header Section
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CustomCircleAvatar(
                  radius: 16.0,
                  srcNetworkImage: snap['profImage'],
                  srcAssetsImage: defaultUserProfilePath,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () =>{
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  uid: snap['uid'],
                                )))
                          },
                          child: Text(snap['username'], style: TextStyle(fontWeight:FontWeight.bold,),),
                        )
                      ],
                    ),
                  ),
                ),

                userProvider!.uid == snap['uid'] ?
                IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context)=>Dialog(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        children: [
                          '삭제',
                        ].map((e) => InkWell(
                            onTap: () async {
                              await FirestoreMethod().deletePost(snap['postId']);
                              Navigator.of(context).pop();
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
                  icon: const Icon(Icons.more_vert),
                ):const Text(''),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethod().likePost(
                  snap['postId'].toString(),
                  userProvider!.uid,
                  snap['likes']
              );
              //like 안했는 사람인지?
              //해당 게시글이 맞는지?

              print('1234');
              if(snap['likes'] != null && !snap['likes'].contains( userProvider?.uid )){
                ref.read(notiPostCardInfoProvider.notifier).state = PostCardInfo(postId: snap['postId'] ,isLikeAnimating: true);
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  child: Image.network(snap['postUrl'], fit: BoxFit.contain,),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 50),
                  opacity: snap['postId'] == postCardInfo!.postId && postCardInfo!.isLikeAnimating? 1:0,
                  child: LikeAnimcation(
                    isAnimating: postCardInfo!.isLikeAnimating,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 130,
                    ),
                    duration: const Duration(milliseconds: 500),
                    onEnd: () {
                      ref.read(notiPostCardInfoProvider.notifier).state = PostCardInfo(isLikeAnimating: false);
                    },
                  ),
                )
              ],
            ),
          ),

          //Link Comment Section
          Row(
            children: [
              LikeAnimcation(
                  isAnimating: snap['likes'] != null ? snap['likes'].contains( userProvider?.uid )  : false,
                  smallLike: true,
                  child: IconButton(onPressed: ()async{

                    await FirestoreMethod().likePost(
                        snap['postId'].toString(),
                        userProvider!.uid,
                        snap['likes']
                    );

                  }, icon: snap['likes'].contains(userProvider?.uid) ?  const Icon(
                    Icons.favorite ,
                    color: Colors.red,
                  ): const Icon(Icons.favorite_border)
                    ,
                  )
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CommentsScreen(
                      snap: snap,
                    ))),
                icon: Icon(
                  Icons.chat_bubble_outline,
                ),
              ),
              /*
              IconButton(onPressed: (){}, icon: Icon(Icons.send,),),
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('미구현'),
                              content: Text('공유 기능은 아직 미구현 입니다.'),
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
                      icon: Icon(Icons.bookmark),
                    ),
                  )
              ),
              */
            ],
          ),

          //Description and number of comments
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    child: Text(
                      '${snap['likes']== null ? 0 : snap['likes'].length} likes' ,
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle( color: primaryColor),
                        children: [
                          TextSpan(
                            text: snap['username'],
                            style: const TextStyle(fontWeight: FontWeight.bold,),
                          ),
                          WidgetSpan(child: SizedBox(width: 10,)),
                          TextSpan(
                            text: snap['description'],
                            style: const TextStyle(fontWeight: FontWeight.bold,),
                          ),
                        ]
                    ),
                  ),
                ),

                InkWell(
                  child: Container(
                    child: FutureBuilder<int>(
                      future: getComments(), // Future 함수 호출
                      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                        // 연결 대기 중
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        // 오류 발생 시
                        if (snapshot.hasError) {
                          return
                            GestureDetector(
                              onTap: ()=>
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => CommentsScreen(
                                        snap: snap,
                                      )))
                              ,
                              child:
                              Text('댓글 0 개 모두보기 ' , style: const TextStyle(
                              fontSize: 16,
                              color: secondaryColor,
                              ),),
                            );
                        }
                        // 데이터가 있을 때
                        return
                          GestureDetector(
                            onTap: ()=>
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => CommentsScreen(
                                      snap: snap,
                                    )))
                            ,
                            child:
                            Text('댓글 ${snapshot.data} 개 모두보기 ' ,
                              style: const TextStyle(
                                fontSize: 16,
                                color: secondaryColor,
                              ),
                            ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric( vertical: 4 ),
                  child: Text(
                    DateFormat('y년 M월 d일').format( snap['datePublished'] == null ? DateTime.now() : snap['datePublished'].toDate() ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }


}