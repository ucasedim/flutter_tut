import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/model/add_post.dart';

class AddPostProvider extends StateNotifier<AddPost?>{

  AddPostProvider(super.state);
  AddPost? addPost;
  AddPost? get getPostFile => addPost;

}
