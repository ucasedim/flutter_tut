import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tut/model/add_post.dart';
import 'package:flutter_tut/resources/auth_methods.dart';
import 'package:flutter_tut/resources/firestore_mehtod.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/utils/utils.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user.dart';

class AddPostScreen extends ConsumerWidget {
  AddPostScreen({Key? key}) : super(key: key);
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final addPostProvider = ref.watch(notiAddPostProcessProvider);
    final userProvider = ref.watch(notiUserProvider);

    print(userProvider?.username);
    print(userProvider?.username);
    print(userProvider?.username);
    print(userProvider?.username);
    print(userProvider?.username);
    print(userProvider?.username);
    print(userProvider?.username);

    void clearImage() {
      ref.read(notiAddPostProcessProvider.notifier).state = AddPost(file:null);
    }
    void postSuccess(BuildContext context) {
      ref.read(layoutWidgetProcessProvider).pageController.jumpToPage(0);
    }
    void postImage(String uid,
        String username,
        String profImage,
        BuildContext context) async {
      /*
    setState(() {
      _isLoading=true;
    });
     */
      try {
        String res = await FirestoreMethod().uploadPost(
            _descriptionController.text,
            addPostProvider!.file!,
            uid,
            username,
            profImage);
        if (res == 'success') {
          showSnackBar('게시 완료!', context);
          _isLoading = false;
          clearImage();
          postSuccess(context);
        } else {
          showSnackBar(res, context);
          _isLoading = false;
        }
      } catch (err) {
        showSnackBar(err.toString(), context);
        _isLoading = false;
      }
    }

    _selectImage(BuildContext context) async {

      final userInfoProvider = ref.watch(notiUserProvider);

      return showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: const Text('작성하기'),
              children: [
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('카메라'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.camera,);
                    ref.read(notiAddPostProcessProvider.notifier).state = AddPost(file: file);
                  },
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('갤러리'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file = await pickImage(ImageSource.gallery);
                    ref.read(notiAddPostProcessProvider.notifier).state = AddPost(file: file);
                  },
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('취소'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }

    return addPostProvider?.file == null?
    //return lp.getFile == null ?
                      GestureDetector(
                      onTap: ()=> _selectImage(context),
          child: Center(
            child: Container(
              child:
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.upload),
                      onPressed: ()=>_selectImage(context),
                  //onPressed: ()=> {},
                ),
                Text(
                  '업로드하기',
                ),
                Text(
                    '${addPostProvider?.file}'
                ),
              ],
            ),
          ),
        ),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: const Text('작성하기'),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () =>
                  postImage(
                      userProvider!.uid,
                      userProvider!.username,
                      userProvider!.photoUrl,
                      context
                  ),
              child: const Text(
                '게시하기',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ))
        ],
      ),
      body: Column(
        children: [
          _isLoading ?
          const LinearProgressIndicator( color: Colors.blueAccent,)
              : Padding(padding: EdgeInsets.only(top:0)),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.width*0.25,
                        width: MediaQuery.of(context).size.width*0.25,
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              image: DecorationImage(
                                image : MemoryImage(addPostProvider!.file!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.65,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.65,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: '글을 작성해주세요',
                        border: InputBorder.none,
                      ),
                      maxLines: 100,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

  }
}