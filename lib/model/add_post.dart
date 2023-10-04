import 'dart:typed_data';
import 'package:flutter/material.dart';

class AddPost {

  final Uint8List file;
  final bool isLoading;

  AddPost({
    required this.file,
    required this.isLoading,
  });

}