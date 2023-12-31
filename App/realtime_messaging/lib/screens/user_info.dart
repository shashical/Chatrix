import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:realtime_messaging/Services/users_remote_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../Models/users.dart';
import 'home_page.dart';

String cid ='';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> with WidgetsBindingObserver {
  File? _image;
  String? imageUrl;
  Users? currentUser;
  bool isUserLoaded = false;
  bool fileUploading = false;

  @override
  void initState() {
    cid=FirebaseAuth.instance.currentUser!.uid;
    try {
      getCurrentUser();
    } on FirebaseAuthException catch (e) {
      setState(() {
        fileUploading = false;
      });
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('${e.message}')));
    } on FirebaseException catch (e) {
      setState(() {
        fileUploading = false;
      });
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('${e.message}')));
    } catch (e) {
      setState(() {
        fileUploading = false;
      });
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$e')));
    }
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {

      RemoteServices().updateUser(cid, {'isOnline':true});
    }
    else {
      RemoteServices().updateUser(cid,{'isOnline':false, 'lastOnline':DateTime.now().toIso8601String()});
    }
  }

  getCurrentUser() async {
    currentUser = await RemoteServices()
        .getSingleUser(FirebaseAuth.instance.currentUser!.uid)
        .catchError((e) => throw Exception('$e'));
    setState(() {
      _usernameController.text = currentUser!.name ?? "";
      _aboutController.text = currentUser!.about ?? "";
      isUserLoaded = true;
      // if (currentUser!.photoUrl != null) {
      //     Uri imageUrl = Uri.parse(currentUser!.photoUrl!);
      //     _downloadImage(imageUrl).then((imageFile) {
      //     setState(() {
      //       _image = imageFile;
      //     });
      // });
      // }
    });
  }

  // Future<File?> _downloadImage(Uri imageUrl) async {
  //   try {
  //     http.Response response = await http.get(imageUrl);
  //     String fileName = imageUrl.pathSegments.last;
  //     Directory tempDir = await getTemporaryDirectory();
  //     File file = File('${tempDir.path}/$fileName');
  //     await file.writeAsBytes(response.bodyBytes);
  //     return file;
  //   } catch (e) {
  //     debugPrint('Error downloading image: $e');
  //     return null;
  //   }
  // }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
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
    // debugPrint('$isUserLoaded');
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
                  const Color.fromARGB(255, 232, 194, 165),
                  Colors.pink.shade200
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 40.0),
                    child: const Text(
                      'Enter Your Profile',
                      style: TextStyle(
                          fontSize: 38.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Caveat'),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {
                    SimpleDialog alert = SimpleDialog(
                      title: const Text("Choose an action"),
                      children: [
                        SimpleDialogOption(
                          onPressed: () {
                            getImage(ImageSource.gallery);
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
                          onPressed: () {
                            getImage(ImageSource.camera);
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
                          : (isUserLoaded)?
                          DecorationImage(
                              image: NetworkImage(currentUser!.photoUrl!),fit: BoxFit.cover)
                              :const DecorationImage(
                              image: NetworkImage("https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1"),fit: BoxFit.cover)
                          ),
                    ),
                    // child: _image == null
                    //     ? Icon(
                    //         Icons.camera_alt,
                    //         size: 40.0,
                    //         color: Colors.grey[500],
                    //       )
                    //     : null,
                  ),

                const SizedBox(height: 20.0),
                TextFormInput(
                  label: 'Username',
                  hintText: 'Enter your desired username',
                  controller: _usernameController,
                ),
                const SizedBox(height: 20.0),
                TextFormInput(
                  label: 'About',
                  hintText: 'Tell us about yourself',
                  maxLines: 3,
                  controller: _aboutController,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          fileUploading = true;
                        });
                        try {
                          final id = FirebaseAuth.instance.currentUser!.uid;
                          if (_image != null) {
                            imageUrl = await RemoteServices()
                                .uploadNewImage(_image!, id);
                          }
                          if(imageUrl!=null){
                            RemoteServices().updateUser(id, {"photoUrl":imageUrl}).catchError((e)=>throw Exception('$e'));
                          }
                          RemoteServices().updateUser(id, {
                            "name": _usernameController.text,
                            "about": _aboutController.text
                          });
                          setState(() {
                            fileUploading = false;
                          });
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                                ModalRoute.withName('/')
                          );
                        } on FirebaseAuthException catch (e) {
                          setState(() {
                            fileUploading = false;
                          });
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                                SnackBar(content: Text('${e.message}')));
                        } on FirebaseException catch (e) {
                          setState(() {
                            fileUploading = false;
                          });
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                                SnackBar(content: Text('${e.message}')));
                        } catch (e) {
                          setState(() {
                            fileUploading = false;
                          });
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(content: Text('$e')));
                        }

                        ;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: (fileUploading)
                          ? const CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            )
                          : const Text(
                              'Done',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            (context),
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomePage()),
                        ModalRoute.withName('/'));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      )

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
          style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5.0),
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
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 15.0,
            ),
          ),
        ),
      ],
    );
  }
}
