import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/resources/auth_methods.dart';
import 'package:flutter_tut/resources/firestore_mehtod.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/custom_circle_avator.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/widgets/comment_card.dart';
class CommentsScreen extends ConsumerWidget {

  final snap;

  CommentsScreen({
    super.key,
    required this.snap
  });

  final TextEditingController _commentController = TextEditingController();

  getUser(WidgetRef ref) async{
    ref.read(notiUserProvider.notifier).state = await AuthMethods().getUserDetails();
  }

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    //final User user = Provider.of<UserProvider>(context).getUser;
    //_commentController.dispose();
    final user = ref.watch(notiUserProvider);
    if(user == null) getUser(ref);


    return Scaffold(
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text('댓글'),
          centerTitle: false,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if((snapshot.data! as dynamic).docs.length == 0){
              return
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text('아직 댓글이 없습니다' , style: TextStyle(fontSize: 25 , fontWeight: FontWeight.bold)),
                  ),
                  const Center(
                    child: Text('댓글을 남겨보세요' , style: TextStyle(fontSize: 15),),
                  ),
                ],
              );
            }

            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length ,
            itemBuilder: (context, index) => CommentCard(
              snap:(snapshot.data! as dynamic).docs[index].data()
            ),
          );
        },
        )
        //CommentCard()
        ,
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            padding: const EdgeInsets.only(left: 16 , right: 8),
            child: Row(
              children: [
                CustomCircleAvatar(
                  radius: 18,
                  srcNetworkImage: user!.photoUrl,
                  srcAssetsImage: defaultUserProfilePath,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16 , right: 8),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: '${user!.username}로 댓글쓰기',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async{
                    await FirestoreMethod().postComment(
                      snap['postId'],
                      _commentController.text,
                      user!.uid,
                      user!.username,
                      user!.photoUrl);
                      _commentController.text = "";
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8 , horizontal: 8,),
                    child: const Text('게시' , style: TextStyle(
                        color: blueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),


          ),
        ),
    );
  }
}
