import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Layout {

  int page;
  Uint8List? file;
  String name;
  PageController pageController;

  Layout({
    required this.page,
    required this.file,
    required this.name,
    required this.pageController,
  });

  Map<String,dynamic> toJson() =>{
    "page" : page,
    "file" : file,
    "name" : name,
    "pageController" : pageController,
  };
/*
  Future<void> setPage(int page) async {
    this.page = page;
    print("this page ${this.page}");
  }
*/

  void navigationTapped(int page){
    print("param page ${page}");
    this.pageController.jumpToPage(page);
  }

  Layout fromToJson ( Map<String,dynamic> json ){
    return Layout(
      page: json['page'],
      file: json['file'],
      name: json['name'],
      pageController: json['pageController'],
    );
  }

  static Layout fromSnap ( DocumentSnapshot snap ){
    var snapshot = snap.data() as Map<String,dynamic>;
    return Layout(
      page: snapshot['page'],
      file: snapshot['file'],
      name: snapshot['name'],
      pageController: snapshot['pageController'],
    );
  }

}