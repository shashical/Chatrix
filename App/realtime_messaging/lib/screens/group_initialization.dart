
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Models/users.dart';

class GroupInitialization extends StatefulWidget {
  final List<String> participantIds;
  final List<Users> users;
  final int index;
  const GroupInitialization({Key? key, required this.participantIds, required this.users, required this.index}) : super(key: key);

  @override
  State<GroupInitialization> createState() => _GroupInitializationState();
}

class _GroupInitializationState extends State<GroupInitialization> {
  File? _image;
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
      appBar: AppBar(
        title: Column(
          children: [
            Text('New Group'),
            Text('add subject'),
          ],
        )

      ),
      body:Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  SimpleDialog alert =
                  SimpleDialog(
                  title: const Text(
                  "Choose an action"),
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                        },
                      child: const Row(
                        children:[
                            Icon(CupertinoIcons.photo,color: Colors.blue,),
                            SizedBox(width: 8.0),
                            Text("Pick from gallery",
                              style: TextStyle(
                                    fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                        ),
                                            ),
                                        ],),),
                        SimpleDialogOption(
                          onPressed: () {
                            getImage(ImageSource.camera);
                            },
                          child: const Row(
                              children: [
                                Icon(Icons.camera_alt,color: Colors.green,),
                                SizedBox(width: 8.0),
                                Text("Capture from camera",
                                  style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              ),
                                              ],
                                              ),
                                              ),
                                            ],);
                            showDialog(context: context,builder: (context) =>
                              alert,barrierDismissible: true,);
                            },),
              const TextField(

              )
            ],
          )
        ],
      )

    );
  }
}
