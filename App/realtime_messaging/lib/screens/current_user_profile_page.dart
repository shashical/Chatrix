
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'dart:io';
import '../Models/users.dart';
import '../Services/users_remote_services.dart';

class CurrentUserProfilePage extends StatefulWidget {
  const CurrentUserProfilePage({Key? key}) : super(key: key);

  @override
  State<CurrentUserProfilePage> createState() => _CurrentUserProfilePageState();
}

class _CurrentUserProfilePageState extends State<CurrentUserProfilePage> {
  Users? currentUser;
  File? _image;
  bool isLoading=true;
  bool photoUploading=false;
  bool nameUpdating=false;
  bool aboutUpdating=false;
  @override
  void initState() {

    // TODO: implement initState
    getCurrentUser();
    super.initState();
  }
  void getCurrentUser()async{
    currentUser=await RemoteServices().getSingleUser(cid);
    setState(() {
      isLoading=false;
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
      resizeToAvoidBottomInset: false,
          body:(isLoading)?const Center(
            child: CircularProgressIndicator(
              color: Colors.cyan,
              strokeWidth: 6,
            ),
          ):Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 22,
                ),
                const Row(
                  children: [
                    BackButton(),
                    SizedBox(
                      width: 18,
                    ),
                    Text('Profile',
                    style: TextStyle(color: Colors.cyan,fontSize: 35,fontWeight: FontWeight.bold),)
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Stack(
                    children:[
                      ClipOval(
                        child: Material(
                          child:(photoUploading)?const Center(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Column(
                                children: [
                                  CircularProgressIndicator(color: Colors.purple,),
                                  Text('Uploading Image'),
                                ],
                              ),
                            ),
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
                                      title: const Text("Choose an action"),
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
                                              RemoteServices().updateUser(cid,{"photoUrl":photoUrl}).catchError((e)=>throw Exception('$e'));
                                              setState(() {
                                                currentUser!.photoUrl=photoUrl;
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
                                          child: const Row(
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
                                              RemoteServices().updateUser(cid,{"photoUrl":photoUrl}).catchError((e)=>throw Exception('$e'));
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
                                          child: const Row(
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
                                        (currentUser!.photoUrl!="https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1")?
                                        SimpleDialogOption(
                                          onPressed: () async{
                                            try {
                                              setState(() {
                                                photoUploading=true;
                                              });

                                              RemoteServices().updateUser(cid,{"photoUrl":"https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1"}).catchError((e)=>throw Exception('$e'));
                                                setState(() {
                                                  currentUser!.photoUrl="https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1";
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



                                            },
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 8.0),
                                              Text(
                                                "Remove profile image",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ):const SizedBox(height: 0,width: 0,),

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
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  trailing:(nameUpdating)?const SizedBox(width: 0,height: 0,): IconButton(
                    onPressed: (){
                      TextEditingController nameController=TextEditingController(text: currentUser!.name);

                      showModalBottomSheet(context: (context),
                        isScrollControlled:true,
                        builder: (context)=> Padding(
                          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              TextField(
                                style: const TextStyle(
                                  fontSize: 28,
                                ),
                                controller: nameController,
                                maxLines: 1,
                                decoration: InputDecoration(

                                  hintText: 'Enter your name ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 15.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                                      ),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                        child: Text('Cancel',
                                          style: TextStyle(fontSize: 26),),
                                      )),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                                    ),
                                    onPressed:(){
                                      try{
                                        setState(() {
                                          nameUpdating=true;
                                        });
                                        RemoteServices().updateUser(cid, {"name":nameController.text}).catchError((e)=>throw Exception('$e'));
                                        setState(() {
                                          currentUser!.name=nameController.text;
                                          nameUpdating=false;
                                        });
                                        Navigator.pop(context);}
                                      on FirebaseException catch(e){
                                        setState(() {
                                          nameUpdating=false;
                                        });
                                        ScaffoldMessenger.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(SnackBar(content: Text('${e.message}')));
                                      }

                                      catch(e)
                                      {
                                        setState(() {
                                          nameUpdating=false;
                                        });
                                        ScaffoldMessenger.of(context)
                                          ..removeCurrentSnackBar()
                                          ..showSnackBar(SnackBar(content: Text('$e')));}
                                    }, child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                                    child: Text('Done',
                                      style: TextStyle(fontSize: 26),),
                                  ),

                                  )
                                ],
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  title: const Text('Name',style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w300),),
                  subtitle: Text(currentUser!.name!,
                    style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 24,color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  trailing:(aboutUpdating)?const SizedBox(width: 0,height: 0,): IconButton(
                    onPressed: (){
                      TextEditingController aboutController=TextEditingController(text: currentUser!.about!);
                      showModalBottomSheet(context: (context),
                          isScrollControlled:true,
                          builder: (context)=> Padding(
                          padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              TextField(
                                style: const TextStyle(
                                  fontSize: 28,
                                ),
                                controller: aboutController,
                                maxLines: null,
                                decoration: InputDecoration(

                                  hintText: 'Enter about yourself ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 15.0,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                                      ),
                                      onPressed: (){
                                    Navigator.pop(context);
                                  },
                                      child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    child: Text('Cancel',
                                      style: TextStyle(fontSize: 26),),
                                  )),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                                    ),
                                    onPressed:(){
                                    try{
                                      setState(() {
                                        aboutUpdating=true;
                                      });
                                      RemoteServices().updateUser(cid, {"about":aboutController.text}).catchError((e)=>throw Exception('$e'));
                                      setState(() {
                                        currentUser!.about=aboutController.text;
                                        aboutUpdating=false;
                                      });
                                      Navigator.pop(context);}
                                    on FirebaseException catch(e){
                                      setState(() {
                                        aboutUpdating=false;
                                      });
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(SnackBar(content: Text('${e.message}')));
                                    }

                                    catch(e)
                                    {
                                      setState(() {
                                        aboutUpdating=false;
                                      });
                                      ScaffoldMessenger.of(context)
                                        ..removeCurrentSnackBar()
                                        ..showSnackBar(SnackBar(content: Text('$e')));}
                                  }, child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                                    child: Text('Done',
                                    style: TextStyle(fontSize: 26),),
                                  ),

                                  )
                                ],
                              ),

                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  title: const Text('About',style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w300),),
                  subtitle: Text(currentUser!.about!,
                    style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 24,color: Colors.black),
                  ),

                ),
                ListTile(
                  leading:const Icon(Icons.phone),
                  title: const Text('Phone',style: TextStyle(color: Colors.grey,fontSize: 18,fontWeight: FontWeight.w300),),
                  subtitle: Text('${currentUser!.phoneNo.substring(0,3)} ${currentUser!.phoneNo.substring(3)}',
                    style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 24,color: Colors.black),
                  ),
                )
              ],
            ),
          ),
    );
  }
}
