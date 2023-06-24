
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'dart:io';
import '../Models/users.dart';
import '../Services/remote_services.dart';

class CurrentUserProfilePage extends StatefulWidget {
  const CurrentUserProfilePage({Key? key}) : super(key: key);

  @override
  State<CurrentUserProfilePage> createState() => _CurrentUserProfilePageState();
}

class _CurrentUserProfilePageState extends State<CurrentUserProfilePage> {
  Users? currentUser;
  File? _image;
  bool isloading=true;
  bool photoUploading=false;

  @override
  void initState() {

    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }
  void getCurrentUser()async{
    currentUser=await RemoteServices().getSingleUser(cid);
    setState(() {
      isloading=false;
    });

  }
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
          body:(isloading)?Center(
            child: CircularProgressIndicator(
              color: Colors.cyan,
              strokeWidth: 6,
            ),
          ):Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                    children:[
                      ClipOval(
                        child: Material(
                          child:(photoUploading)?Column(
                            children: [
                              CircularProgressIndicator(color: Colors.purple,),
                              Text('Uploading Image'),
                            ],
                          ): Image(
                            image:NetworkImage(currentUser!.photoUrl!),
                            fit:BoxFit.cover ,
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: ClipOval(
                          child: Container(
                            padding: EdgeInsets.all(7),
                            color: Colors.white,
                            child: ClipOval(
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                color: Colors.lightBlue,
                                child:  IconButton(
                                  onPressed: (){
                                    SimpleDialog alert = SimpleDialog(
                                      title: Text("Choose an action"),
                                      children: [
                                        SimpleDialogOption(
                                          onPressed: () async{
                                            await getImage(ImageSource.gallery);
                                            if(_image!=null)
                                            {try {
                                              setState(() {
                                                photoUploading=true;
                                              });
                                              String photoUrl=await RemoteServices().uploadNewImage(
                                                  _image!, cid).catchError((e)=>throw Exception('$e'));
                                              RemoteServices().updateUser(cid,{photoUrl:photoUrl}).catchError((e)=>throw Exception('$e'));
                                              setState(() {
                                                photoUploading=false;
                                              });

                                            }on FirebaseException catch(e){
                                              setState(() {
                                                photoUploading=false;
                                              });
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(SnackBar(content: Text('${e.message}')));
                                            }

                                            catch(e)
                                            {
                                             setState(() {
                                               photoUploading=false;
                                             });
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(SnackBar(content: Text('$e')));}


                                            }
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
                                          onPressed: () async{
                                            await getImage(ImageSource.camera);
                                            if(_image!=null)
                                            {try {
                                              setState(() {
                                                photoUploading=true;
                                              });
                                              String photoUrl=await RemoteServices().uploadNewImage(
                                                  _image!, cid).catchError((e)=>throw Exception('$e'));
                                              RemoteServices().updateUser(cid,{photoUrl:photoUrl}).catchError((e)=>throw Exception('$e'));
                                                setState(() {
                                                  photoUploading=false;
                                                });
                                            }on FirebaseException catch(e){
                                              setState(() {
                                                photoUploading=false;
                                              });

                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(SnackBar(content: Text('${e.message}')));
                                            }

                                            catch(e)
                                            {
                                              setState(() {
                                                photoUploading=false;
                                              });
                                              ScaffoldMessenger.of(context)
                                                ..removeCurrentSnackBar()
                                                ..showSnackBar(SnackBar(content: Text('$e')));}


                                          }
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
                                  icon: const Icon(
                                      Icons.edit
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )

                    ]
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  trailing: IconButton(
                    onPressed: (){
                      TextEditingController _nameController=TextEditingController(text: currentUser!.name);
                      TextEditingController _aboutController=TextEditingController();
                          showModalBottomSheet(context: (context), builder: (context)=>SizedBox(

                            child: TextField(

                              controller: _nameController,
                              maxLines: 1,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: (){
                                     // try{RemoteServices().updateUser(id, upd)}
                                  },
                                  icon: Icon(Icons.done),
                                ),
                                hintText: 'Enter your Name ',
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

                          ));
                    },
                    icon: Icon(Icons.edit),
                  ),
                  title: Text('Name',style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w300),),
                  subtitle: Text(currentUser!.name!,
                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24,color: Colors.black),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  trailing: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.edit),
                  ),
                  title: Text('About',style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w300),),
                  subtitle: Text(currentUser!.about!,
                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24,color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
