import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../log/test_logger.dart';
import '../model/user.dart' as model;
import 'storage_methods.dart';


class AuthMethods {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }


  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
      String res = "Some error occurred";
      try{

        if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file != null){

          UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

          print(cred.user!.uid);

          String photoUrl = await StorageMethods().uploadImageToStroage('profileePics', file, false);


          model.User user = model.User(
            bio: bio,
            email: email,
            followers: [],
            following: [],
            photoUrl: photoUrl,
            uid: cred.user!.uid,
            username: username,
          );

          print('photourl  ::  $photoUrl');


          await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);

          res = "success";
        }

      } on FirebaseException catch (err){
        if(err.code == 'invalid-email'){
          res = 'The email is badly formatted.';
        }else if(err.code == 'weak-password'){
          res = 'Password should be at least 6 characters';
        }
      } catch(err){
        res = err.toString();
      }
      return res;
  }


  Future<String> loginUser({
    required String email,
    required String password
  }) async {
    String res = "some one error";
    loggerNoStack.i(res);
    try{

      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);

        res = "success";
      }else{
        res = "Please enter all the fields";
      }
    }on FirebaseException catch (err){
      return err.toString();
    }catch(err){
      res = err.toString();
    }

    return res;
  }

}