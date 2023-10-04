import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/providers/file_model.dart';

class PostFileNotifier extends StateProvider<Uint8List>{

  PostFileNotifier(super.createFn);
  Uint8List? _postfile;

  Uint8List? get getPostFile => _postfile;

  void setFile(Uint8List file){
    _postfile = file;
  }


}