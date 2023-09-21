import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:flutter_tut/resources/firestore_mehtod.dart';
import 'package:flutter_tut/screen/comment_screeen.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/utils/utils.dart';
import 'package:flutter_tut/widgets/like_animations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    super.key,
    required this.snap
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating = false;
  int commentLen = 0;


  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async{
    try {
      QuerySnapshot _snap = await FirebaseFirestore.instance.collection('posts')
          .doc(widget.snap['postId']).collection('comments')
          .get();

      commentLen = _snap.docs.length;

      showSnackBar(commentLen.toString() , context);

    }catch(err){
      showSnackBar(err.toString(), context);
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
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
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                      widget.snap['profImage']
                  ),
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
                        Text(widget.snap['username'] , style: TextStyle(fontWeight:FontWeight.bold,),),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(context: context, builder: (context)=>Dialog(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shrinkWrap: true,
                        children: [
                          'Delete',
                        ].map((e) => InkWell(
                          onTap: () async {
                            await FirestoreMethod().deletePost(widget.snap['postId']);
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
                ),
              ],
            ),
          ),

          //Image Section
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethod().likePost(
                  widget.snap['postId'].toString(),
                  user.uid,
                  widget.snap['likes']
              );

              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  child: Image.network(widget.snap['postUrl'], fit: BoxFit.contain,),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating? 1:0,
                  child: LikeAnimcation(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 130,
                      ),
                      isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 300),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
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
                isAnimating: widget.snap['likes'] != null ? widget.snap['likes'].contains( user.uid )  : false,
                  smallLike: true,
                  child: IconButton(onPressed: ()async{

                    await FirestoreMethod().likePost(
                        widget.snap['postId'].toString(),
                        user.uid,
                        widget.snap['likes']
                    );

                    }, icon: widget.snap['likes'].contains(user.uid) ?  const Icon(
                      Icons.favorite ,
                      color: Colors.red,
                    ): const Icon(Icons.favorite_border)
                    ,
                  )
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CommentsScreen(
                      snap: widget.snap,
                    ))),
                icon: Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.send,),),
              Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.bookmark),
                    ),
                  )
              ),
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
                      '${widget.snap['likes']== null ? 0 : widget.snap['likes'].length} likes' ,
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
                          text: widget.snap['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(
                          text: widget.snap['description'],
                          style: const TextStyle(fontWeight: FontWeight.bold,),
                        )
                      ]
                    ),
                  ),
                ),

                InkWell(
                  child: Container(
                    child: Text('View all $commentLen comments ' , style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric( vertical: 4 ),
                  child: Text(
                    DateFormat.yMMMd().format( widget.snap['datePublished'] == null ? DateTime.now() : widget.snap['datePublished'].toDate() ),
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
