import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostCardInfo {

  String? postId;
  bool isLikeAnimating;

  PostCardInfo({
    this.postId,
    required this.isLikeAnimating,
  });

}