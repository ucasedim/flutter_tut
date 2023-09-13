import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_mehtod.dart';
import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key,
  required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {

  final TextEditingController _commentController = TextEditingController();


  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text('comment'),
          centerTitle: false,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.snap['postId'])
            .collection('comments')
            .orderBy('datePublished', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
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
                CircleAvatar(
                  backgroundImage:
                  user != null && user.photoUrl.isNotEmpty?
                  NetworkImage(user.photoUrl)
                  :
                  NetworkImage('https://images.unsplash.com/photo-1606041008023-472dfb5e530f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1976&q=80')
                  ,
                  radius:18,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16 , right: 8),
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'comment as ${user.username}',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async{
                    await FirestoreMethod().postComment(
                      widget.snap['postId'],
                      _commentController.text,
                      user.uid,
                      user.username,
                      user.photoUrl);

                    setState(() {
                      _commentController.text = "";
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8 , horizontal: 8,),
                    child: const Text('Post' , style: TextStyle(
                        color: blueColor,
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
