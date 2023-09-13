import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/resources/auth_methods.dart';
import 'package:flutter_tut/resources/firestore_mehtod.dart';
import 'package:flutter_tut/screen/login_screen.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/utils.dart';

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

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator(),) :
    Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text(
              userData['username'] != null ? userData['username'] : '???ERROR???'
          ),
          centerTitle: false,
        ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column( children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: mobileBackgroundColor,
                      backgroundImage:
                          userData['photoUrl'] != null ?
                              NetworkImage(userData['photoUrl'])
                              :
                              NetworkImage('https://images.unsplash.com/photo-1606041008023-472dfb5e530f?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1976&q=80'),
                      radius: 40,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStatColumn(postLen , "posts"),
                                buildStatColumn(followers , "follower"),
                                buildStatColumn(following , "following"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid == widget.uid ?
                                FollowButton(
                                  //text: 'Edit Profile',
                                  text: 'Sign Out',
                                  backgroundColor: mobileBackgroundColor,
                                  textColor: primaryColor,
                                  borderColor: Colors.grey,
                                  function: () async {
                                    await AuthMethods().signOut();
                                    Navigator
                                        .of(context)
                                        .pushReplacement(
                                           MaterialPageRoute(
                                             builder: (context) => const LoginScreen(),
                                           ),
                                        );
                                  },
                                ):isFollowing ? FollowButton(
                                  text: 'UnFollower',
                                  backgroundColor: Colors.white,
                                  textColor: Colors.black,
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
                                  text: 'Follower',
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
                              ],
                            ),
                          ],
                      ),
                    ),

                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top:15),
                  child: Text(
                    'username' ,
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
        ],
      ),
    );
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
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400 , color: Colors.grey),
          ),
        ),
      ],
    );
  }

}
