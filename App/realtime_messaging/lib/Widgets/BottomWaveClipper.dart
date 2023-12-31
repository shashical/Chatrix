
import 'package:flutter/cupertino.dart';

class BottomWaveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path=new Path();
    path.lineTo(0.0,size.height-size.height/6);
    path.quadraticBezierTo(
        size.width/4,size.height-(size.height/3),size.width/2, size.height-size.height/6);
    path.quadraticBezierTo(size.width-(size.width/4), size.height,
        size.width, size.height-size.height/6);
    path.lineTo(size.width,0.0);
    path.close();
    return path;

  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return false;
  }
}
