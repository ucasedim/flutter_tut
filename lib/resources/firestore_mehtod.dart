import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tut/resources/storage_methods.dart';
import 'package:flutter_tut/utils/utils.dart';
import 'package:uuid/uuid.dart';

import '../log/test_logger.dart';
import '../model/post.dart';

class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateNotification(
      String userId ,
      Map<String , bool>? userSubscribeData) async{

    try {
      List<Map<String, bool>> setData = [];

      userSubscribeData?.forEach((key, value) {
        setData.add({key: value});
      });

      await _firestore.collection('users').doc(userId).update({
        'notification': setData,
      });
    }catch(e){
      print(e);
    }

  }

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error occurred";

    try {
      String photoUrl = await StorageMethods().uploadImageToStroage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid , List likes) async {
    try{
      if(likes.contains(uid)){
        await _firestore.collection('posts').doc(postId).update({
          'likes':FieldValue.arrayRemove([uid]),
        });
      }else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    }catch(e){
      logger.e(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name, String profilePic) async {

    try{
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();

        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name' : name,
          'uid' : uid,
          'text' : text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      }else{
        logger.i('text is empty' , time: DateTime.now());
      }
    }catch(err){
      logger.i(err.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try{

      _firestore.collection('posts').doc(postId).delete();

    }catch(err){
      logger.e(err.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    try{
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    
    List following = (snap.data()! as dynamic)['following'];
    if(following.contains(followId)){
      await _firestore.collection('users').doc(followId).update({
        'followers':FieldValue.arrayRemove([uid]),
      });
      await _firestore.collection('users').doc(uid).update({
        'following':FieldValue.arrayRemove([followId]),
      });
    }else{
      await _firestore.collection('users').doc(followId).update({
        'followers':FieldValue.arrayUnion([uid]),
      });
      await _firestore.collection('users').doc(uid).update({
        'following':FieldValue.arrayUnion([followId]),
      });
    }
    
    }catch(e){
      logger.e(e.toString());
    }
  }

}
