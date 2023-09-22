import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/providers/layout_widget_provider.dart';
import 'package:flutter_tut/providers/user_provider.dart';
import 'package:flutter_tut/resources/firestore_mehtod.dart';
import 'package:flutter_tut/responsive/mobile_screen_layout.dart';
import 'package:flutter_tut/responsive/web_screen_layout.dart';
import 'package:flutter_tut/screen/feed_screen.dart';
import 'package:flutter_tut/utils/colors.dart';
import 'package:flutter_tut/utils/global_variables.dart';
import 'package:flutter_tut/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  LayoutWidgetProvider lp = LayoutWidgetProvider();

  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    lp.onUpdated = () => setState((){logger.w("setstate call!!! addPost");});
  }

  void postImage(
      String uid,
      String username,
      String profImage
      ) async {
      setState(() {
        _isLoading=true;
      });
      try{
        String res = await FirestoreMethod().uploadPost(
            _descriptionController.text,
            _file!,
            uid,
            username,
            profImage);


        if(res == 'success'){
          showSnackBar('게시 완료!', context);
          setState(() {
            _isLoading = false;
          });
          clearImage();
          postSuccess();
        }else{
          showSnackBar(res, context);
          setState(() {
            _isLoading = false;
          });
        }
      }catch(err){
        showSnackBar(err.toString(), context);
        setState(() {
          _isLoading = false;
        });
      }
  }

  @override
  void dispose(){
    super.dispose();
    _descriptionController.dispose();
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
    showSnackBar('file = null', context);
  }

  void postSuccess(){
    loggerNoStack.e("getLayoutPage : ${LayoutWidgetProvider().getPage()}");
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MobileScreenLayout()
    ));
  }

  _selectImage(BuildContext context ) async{
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('작성하기'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('카메라'),
                onPressed: () async{
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera,);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('갤러리'),
                onPressed: () async{
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
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




  @override
  Widget build(BuildContext context) {

    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null?
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
                      ),
                      Text(
                          '업로드하기',
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
                            user.uid,
                            user.username,
                            user.photoUrl
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
                /*
                Container(
                  child: Center(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photoUrl,
                      ),
                    ),
                  ),
                ),
                */
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
                                image : MemoryImage(_file!),
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
