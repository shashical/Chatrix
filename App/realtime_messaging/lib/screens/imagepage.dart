import 'package:flutter/material.dart';
import 'dart:io';

class ImageScreen extends StatefulWidget {
   const ImageScreen({Key? key,required this.path}) : super(key: key);
   final  String path;

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      body: Stack(

        children: [

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            decoration:
            BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(widget.path)),
                fit: BoxFit.scaleDown
              )
            ),
          ),
          const Positioned(top: 30,
              left: 5,
              child: BackButton( color: Colors.white70,)),

        ],
      ),
    );
  }
}
