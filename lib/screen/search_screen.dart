import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/screen/profile_screen.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/utils.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../log/test_logger.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {


  final TextEditingController _searchController= TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: '사용자 검색',
          ),
          onFieldSubmitted: (String _){
            setState(() {
              isShowUser = true;
            });
            logger.i(_);

            if(_.isEmpty){
              setState(() {
                isShowUser = false;
              });
            }

          },
        ),
      ),
      body: isShowUser ? FutureBuilder(
        future: FirebaseFirestore.instance.collection('users')
            .where('username', isGreaterThanOrEqualTo: _searchController.text)
            .get(),
        builder: (context , snapshot){
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index){

                logger.w(index.toString());
                logger.w(snapshot.data);
                logger.w((snapshot.data! as dynamic).docs[index]);
                return InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                                uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid'],
                              ))),
                      child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          (((snapshot.data! as dynamic).docs[index] as DocumentSnapshot).data() as Map<String,dynamic>).containsKey('photoUrl')  ?
                          (snapshot.data! as dynamic).docs[index]['photoUrl'] : ''
                      ),
                    ),
                    title:
                      Text((snapshot.data! as dynamic).docs[index]['username']),
                  ),
                );
              },
          );
        },
      )
      : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: const CircularProgressIndicator()
                  );
                }
                final documents = snapshot.data?.docs;
                /*검색 안했을떄 기본 그리드 화면 구현하는건데 라이브러리 부분이 달라져서 해당 부분이 확인 해봐야할듯*/
                return GridView.builder(
                    shrinkWrap: true,
                    itemCount: documents == null ? 0 : documents.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
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
    );
  }
}
