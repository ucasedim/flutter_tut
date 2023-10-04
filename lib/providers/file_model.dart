import 'dart:typed_data';

import 'package:flutter/material.dart';

@immutable
class PostFile {
  const PostFile({required this.file});

  final Uint8List? file;

  PostFile copyWith({Uint8List? file}) {
    return PostFile(
      file: file ?? this.file,
    );
  }
}