import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:realtime_messaging/Services/remote_services.dart';
import 'package:realtime_messaging/screens/my_chats.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:realtime_messaging/screens/search_contacts.dart';
import '../Models/users.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


final cid=FirebaseAuth.instance.currentUser!.uid;

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  File? _image;
  String? imageUrl;
  Users? currentUser;
  bool fileUploading=false;

  void initState(){
    getCurrentUser();
    super.initState();
  }

  getCurrentUser()async {
    currentUser=await RemoteServices().getSingleUser(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      _usernameController.text=currentUser!.name ?? "";
      _aboutController.text=currentUser!.about ?? "";
      if (currentUser!.photoUrl != null) {
          Uri imageUrl = Uri.parse(currentUser!.photoUrl!);
          _downloadImage(imageUrl).then((imageFile) {
          setState(() {
            _image = imageFile;
          });
      });
      }
    });
  }

  Future<File?> _downloadImage(Uri imageUrl) async {
    try {
      http.Response response = await http.get(imageUrl);
      String fileName = imageUrl.pathSegments.last;
      Directory tempDir = await getTemporaryDirectory();
      File file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (e) {
      debugPrint('Error downloading image: $e');
      return null;
    }
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  firebase_storage.FirebaseStorage storage =firebase_storage.FirebaseStorage.instance;
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
                        setState(() {
                          fileUploading=true;
                        });
                        try{

                        final id=FirebaseAuth.instance.currentUser!.uid;
                        if(_image!=null) {
                          firebase_storage.Reference ref = firebase_storage
                              .FirebaseStorage.instance.ref(
                              '/Profile_images/$id');
                          firebase_storage.UploadTask uploadTask = ref.putFile(
                              _image!.absolute);
                          await Future.value(uploadTask).catchError((e)=>throw Exception('$e'));
                           imageUrl=await ref.getDownloadURL().catchError((e)=>throw Exception('$e'));
                        }

                        RemoteServices().updateUser(id,{
                          "name":_usernameController.text,
                          "photoUrl":(imageUrl==null)? 'https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1':imageUrl,
                          "about":_aboutController.text

                        });
                        setState(() {
                          fileUploading=false;
                        });
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context)=>SearchContactPage()));
                        }on FirebaseAuthException catch(e){
                          setState(() {
                            fileUploading=false;
                          });
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text('${e.message}')));
                        } on FirebaseException catch(e){
                          setState(() {
                            fileUploading=false;
                          });
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text('${e.message}')));
                        }

                        catch(e)
                             {
                               setState(() {
                                 fileUploading=false;
                               });
                               ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(SnackBar(content: Text('$e')));}

                        ;

                        
                      },
                      child:(fileUploading)?CircularProgressIndicator(strokeWidth: 3,color: Colors.white,): Text(
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
                            MaterialPageRoute(builder: (context)=>SearchContactPage()));
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