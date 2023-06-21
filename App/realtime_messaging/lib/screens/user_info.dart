import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:realtime_messaging/screens/my_chats.dart';

import '../Models/users.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  File? _image;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    }
    final imageTemp = File(image.path);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      _image = imageTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 232, 194, 165),
                  Colors.pink.shade200
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 40.0),
                child: Text(
                  'Enter Your Profile',
                  style: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold,fontFamily: 'Caveat'),
                ),
              ),
            ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    SimpleDialog alert = SimpleDialog(
                      title: Text("Choose an action"),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.photo,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "Pick from gallery",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: Colors.green,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                "Capture from camera",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                    showDialog(
                      context: context,
                      builder: (context) => alert,
                      barrierDismissible: true,
                    );
                  },
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                      image: _image != null
                          ? DecorationImage(
                              image: FileImage(_image!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _image == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 40.0,
                            color: Colors.grey[500],
                          )
                        : null,
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormInput(
                  label: 'Username',
                  hintText: 'Enter your desired username',
                  controller: _usernameController,
                ),
                SizedBox(height: 20.0),
                TextFormInput(
                  label: 'About',
                  hintText: 'Tell us about yourself',
                  maxLines: 3,
                  controller: _aboutController,
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                        try{
                        final auth=await FirebaseAuth.instance.currentUser!.uid;
                        final ref=await FirebaseFirestore.instance.collection('users').doc(auth);
                       await  ref.update({"name":_usernameController.text,
                                      "photoUrl":_image,
                                      "about":_aboutController.text

                        }).catchError((e)=>{
                          throw Exception('$e')
                       });
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context)=>MyChatsPage()));
                        }on FirebaseAuthException catch(e){
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text('${e.message}')));
                        } on FirebaseException catch(e){
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text('${e.message}')));
                        }

                        catch(e)
                             { ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(SnackBar(content: Text('$e')));}

                        ;

                        
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement((context),
                            MaterialPageRoute(builder: (context)=>MyChatsPage()));
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextFormInput extends StatelessWidget {
  final String? label;
  final String? hintText;
  final int maxLines;
  final TextEditingController controller;

  const TextFormInput({
    Key? key,
    this.label,
    this.hintText,
    this.maxLines = 1,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label!,
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5.0),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 15.0,
            ),
          ),
        ),
      ],
    );
  }
}