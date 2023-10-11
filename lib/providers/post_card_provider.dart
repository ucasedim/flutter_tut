import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/model/post_card_info.dart';

class PostCardProvider extends StateNotifier<PostCardInfo?> {
  PostCardProvider(super.state);
  PostCardInfo? postCardInfo;
  PostCardInfo? get getPostCardInfo => postCardInfo;

  setPostCardInfo(PostCardInfo postCardInfo){
    this.postCardInfo = postCardInfo;
  }

}