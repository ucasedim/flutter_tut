import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/widgets/post_card.dart';

class FeedScreen extends ConsumerWidget{
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: width > webScreenSize ? null : AppBar(
        backgroundColor: width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_wow_logo.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: (){
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
            icon: Icon(Icons.message_outlined),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished' , descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context , index) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width> webScreenSize ? width*0.3:0,
                  vertical: width> webScreenSize ? 15:0,
                ),
                child: PostCard(
                  snap:snapshot.data!.docs[index].data(),
                ),
              ));
        },
      ),
    );
  }
}