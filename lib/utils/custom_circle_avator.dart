import 'dart:io';
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
  late String _srcNetworkImage;
  late String _srcAssetsImage;
  late bool _returnConfirm;

  @override
  void initState() {
    super.initState();
    _radius = widget.radius;
    _srcNetworkImage = widget.srcNetworkImage;
    _srcAssetsImage = widget.srcAssetsImage;

    try {
      _currentImage = NetworkImage(widget.srcNetworkImage);
    }catch(e){
      _currentImage = AssetImage(widget.srcAssetsImage);
    }
    _returnConfirm = true;
  }

  @override
  Widget build(BuildContext context) {
    try {
      HttpClient().getUrl(Uri.parse(_srcNetworkImage))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
        if (response.statusCode == 200) {
          _currentImage = NetworkImage(_srcNetworkImage);
        } else {
          _currentImage = AssetImage(_srcAssetsImage);
        }
      });
    } catch (e) {
      _currentImage = AssetImage(_srcAssetsImage);
    }
    return CircleAvatar(radius: _radius ,backgroundImage: _currentImage);
  }
}