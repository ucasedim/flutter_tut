import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tut/log/test_logger.dart';
import 'package:flutter_tut/utils/global_variables.dart';

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
  late ImageProvider _srcNetworkImage2;
  late ImageProvider _srcAssetsImage2;
  late String _srcNetworkImage;
  late String _srcAssetsImage;
  late bool _returnConfirm;

  @override
  void initState() {
    super.initState();
    //logger.i("widget.srcNetworkImage");
    //logger.i(widget.srcNetworkImage);
    _radius = widget.radius;

    _srcNetworkImage = widget.srcNetworkImage;
    _srcAssetsImage = widget.srcAssetsImage;

    try {
      _currentImage = NetworkImage(widget.srcNetworkImage);
    }catch(e){
      _currentImage = AssetImage(widget.srcAssetsImage);
    }
    //_currentImage = _srcNetworkImage; //init
    _returnConfirm = true;
  }

  @override
  Widget build(BuildContext context) {

    try {
      // 유효하지 않은 URL로 HTTP 요청 시도
      HttpClient().getUrl(Uri.parse(_srcNetworkImage))
          .then((HttpClientRequest request) => request.close())
          .then((HttpClientResponse response) {
        // HTTP 응답 처리
        if (response.statusCode == 200) {
          // 성공적인 응답 처리
          //print("Success: ${response.statusCode}");
          //print("uri :  ${_srcNetworkImage}");
          _currentImage = NetworkImage(_srcNetworkImage);
        } else {
          // 응답 상태 코드에 따른 처리
          //print("HTTP Error: ${response.statusCode}");
          _currentImage = AssetImage(_srcAssetsImage);
        }
      });
    } catch (e) {
      // "No host specified in URI" 예외 처리
      logger.e("Error: $e");
      _currentImage = AssetImage(_srcAssetsImage);
    }
    return CircleAvatar(radius: _radius ,backgroundImage: _currentImage);
  }

  Future<ImageProvider?> _loadImage() async {
    try {
      final networkImage = NetworkImage(_srcNetworkImage);
      await networkImage.obtainKey(const ImageConfiguration());
      return networkImage;
    } catch (e) {
      // "no host specified in URI" 오류가 발생한 경우, 에러 처리 또는 대체 이미지를 반환합니다.
      logger.e("Error loading network image: $e");
      return null; // 또는 에러 처리를 원하는 방식으로 변경할 수 있습니다.
    }
  }
}