import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatefulWidget {

  final double radius;
  final String srcNetworkImage;
  final String srcAssetsImage;
  const CustomCircleAvatar({
    super.key,
    required this.radius,
    required this.srcNetworkImage,
    required this.srcAssetsImage,
  });

  @override
  State<CustomCircleAvatar> createState() => _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
  late ImageProvider  _currentImage;
  late double _radius;
  late ImageProvider _srcNetworkImage;
  late ImageProvider _srcAssetsImage;
  bool _returnConfirm = true;

  @override
  void initState() {
    super.initState();
    print("widget.srcNetworkImage");
    print(widget.srcNetworkImage);
    _radius = widget.radius;
    _srcNetworkImage = NetworkImage(widget.srcNetworkImage);
    _srcAssetsImage = AssetImage(widget.srcAssetsImage);
    _currentImage = _srcNetworkImage; //init
  }

  @override
  Widget build(BuildContext context) {
    print("post call");
    CircleAvatar(
      radius: _radius,
      backgroundImage: _currentImage,
      onBackgroundImageError: (exception, stackTrace) {
        print("post currentImage Error");
          _returnConfirm = false;
          _currentImage = _srcAssetsImage;
      },
    );
    if(_returnConfirm) {
      print("network return");
      return CircleAvatar(
        radius: _radius,
        backgroundImage: _currentImage,
        onBackgroundImageError: (exception, stackTrace) {
          print("post currentImage Error");
          _returnConfirm = false;
          _currentImage = _srcAssetsImage;
        },
      );
    }else {
      print("assets return");
      _currentImage = _srcAssetsImage;
      return CircleAvatar(
        radius: _radius,
        backgroundImage: _currentImage,
        onBackgroundImageError: (exception, stackTrace) {
          print("post currentImage Error");
          setState(() {
            _currentImage = _srcAssetsImage;
          });
        },
      );
    }
  }

}