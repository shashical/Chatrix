
//import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:realtime_messaging/Models/chatMessages.dart';
import 'package:realtime_messaging/Models/chats.dart';

import 'package:realtime_messaging/Models/users.dart';
import 'package:realtime_messaging/Services/send_notifications.dart';
import 'package:realtime_messaging/Services/users_remote_services.dart';
import 'package:realtime_messaging/Widgets/progress-indicator.dart';
import 'package:realtime_messaging/main.dart';
import 'package:realtime_messaging/screens/home_page.dart';
import 'package:realtime_messaging/screens/otherUser_profile_page.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'dart:math'as math;
import '../Models/userChats.dart';
import '../Services/chats_remote_services.dart';
import'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart' as rsa;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../constants.dart';
import '../theme_provider.dart';

late Users otheruser;
UserChat? otherUserChat;
Users? otherUserStream;

class DocBuble extends StatefulWidget {
  const DocBuble({Key? key, required this.message, required this.time, required this.senderUrl, required this.id, required this.chatId, required this.receiverUrl, required this.isUser, required this.delivered, required this.read, required this.isSelected, required this.uploaded, required this.downloaded, required this.contentType}) : super(key: key);
  final String message, time,senderUrl,id,chatId,receiverUrl,contentType;
  final bool isUser, delivered, read,isSelected,uploaded,downloaded;

  @override
  State<DocBuble> createState() => _DocBubleState();
}

class _DocBubleState extends State<DocBuble> {
  late Color bg; // =widget.isSelected?Colors.lightBlue.withOpacity(0.5): !widget.isUser ? Colors.white : Colors.greenAccent.shade100;
  late Color dbg; // =widget.isSelected?Colors.lightBlue.withOpacity(0.5): !widget.isUser ? Colors.white : Colors.greenAccent.shade100;
  late CrossAxisAlignment align;
  late IconData icon;
  late BorderRadius radius;
  late bool uploaded;
  late bool downloaded;
  UploadTask? _uploadTask;
  DownloadTask? _downloadTask;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploaded = widget.uploaded;
    downloaded=widget.downloaded;
    bg = widget.isSelected ? Colors.lightBlue.withOpacity(0.5) : !widget.isUser
        ? Colors.white
        : Colors.greenAccent.shade100;
    dbg = widget.isSelected ? Colors.lightBlue.withOpacity(0.5) : !widget.isUser
        ? const Color.fromARGB(255, 72, 69, 69)
        : Color.fromARGB(255, 30, 75, 31);
    align = !widget.isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    icon = widget.read ? Icons.done_all : Icons.done;
    radius = widget.isUser ? const BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    )
        : const BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    );
  }

  Future<String> uploadDocument(File doc) async {
    try {
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref(
          '/chatdoc/${DateTime.now().microsecondsSinceEpoch}');
      _uploadTask = ref.putFile(doc);
      await Future.value(_uploadTask).catchError((e) => throw Exception('$e'));

      return ref.getDownloadURL().catchError((e) => throw Exception('$e'));
    } catch (e) {
      rethrow;
    }
  }

  Future<String> downloadImage(String imageUrl) async {
    try {

      final ref = firebase_storage.FirebaseStorage.instance.refFromURL(
          imageUrl);


      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/${widget.contentType.substring(8)}';

      _downloadTask = ref.writeToFile(File(tempPath));

      await Future.value(_downloadTask).catchError((e) =>
      throw Exception('$e'));
      return tempPath;
    } catch (e) {
      rethrow;
    }

  }
  bool downloading = false;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return  Container(
      color:(widget.isSelected)? Colors.blue.withOpacity(0.5):null,
      child: Column(
        crossAxisAlignment: align,
        children: [
          Builder(
            builder: (context) {
              final themeProvider=Provider.of<ThemeProvider>(context,listen: false);
              return Container(
                constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                margin: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                color: themeProvider.isDarkMode?dbg:bg,
                borderRadius: radius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                 Container(
                   constraints:
                   (widget.isUser)?
                   (uploaded)?
                   BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.62):
                   BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.73):
                   (downloaded)?
                   BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.62):
                   BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.73),

                   child: InkWell(
                     onTap: (){
                       if(!widget.isSelected) {
                         OpenFile.open(widget.isUser?widget.senderUrl:widget.receiverUrl);
                       }
                     },
                     child: Row(
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 8,top:8),
                           child: Container(
                               width: 40,
                                  height: 40,
                                color: Colors.deepOrangeAccent,
                               child: const Icon(CupertinoIcons.doc,color: Colors.white70,),
                           ),
                         ),
                         Container(
                           padding: const EdgeInsets.all(5),
                           constraints:
                           BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.48),
                           child: Text(widget.contentType.substring(8),

                           ),
                         ),
                         (widget.isUser) ? (!isUploading && !uploaded) ? IconButton(
                             onPressed: () async {
                               setState(() {
                                 isUploading = true;
                               });
                               final docUrl = await uploadDocument(
                                   File(widget.senderUrl));
                                if (otherUserStream!.token != null && otherUserStream!.current!=widget.chatId && otherUserChat!.muted == false) {
                                      SendNotificationService().sendFCMChatMessage(
                                          otherUserStream!.token!,
                                          {'title': (otherUserChat!.displayName ?? curUser!.phoneNo), 'body': "Document"},
                                          {});
                                    }

                               String symmKeyString = (await const FlutterSecureStorage().read(key: widget.chatId))!;
                               encrypt.Key symmKey = encrypt.Key.fromBase64(symmKeyString);
                               encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(symmKey,padding: null));
                               encrypt.Encrypted encryptedDocUrl = encrypter.encrypt(docUrl,iv: iv);
                               String encryptedDocUrlString = encryptedDocUrl.base64;

                               ChatsRemoteServices().updateChatMessage(widget.chatId, {
                                 'uploaded': true,
                                 'text': encryptedDocUrlString
                               }, widget.id);
                               setState(() {
                                 uploaded = true;
                               });
                             }, icon: const Icon(Icons.upload))
                             : (!uploaded) ? progressIndicator(_uploadTask,null)
                             : const SizedBox(width: 0,) :
                         (!downloading && !downloaded)?IconButton(
                             onPressed: () async {
                               setState(() {
                                 downloading=true;
                               });
                               final receiveUrl=await downloadImage(widget.message);
                               ChatsRemoteServices().updateChatMessage(widget.chatId,
                                   {'receiverUrl':receiveUrl,
                                     'downloaded':true,
                                   }, widget.id);
                               setState(() {
                                 downloaded=true;
                               });


                             }, icon: const Icon(Icons.download)):!downloaded?progressIndicator(null, _downloadTask):const SizedBox(width: 0,),


                       ],
                     ),
                   ),
                 ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 55.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.time,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        (widget.isUser) ? Icon(
                          icon,
                          size: 16,
                        ) : const SizedBox(width: 0,)
                      ],
                    ),
                  ),
                ],
              ),);
            }
          ),
        ],
      ),
    );
  }
}



class ImageBubble extends StatefulWidget {
  const ImageBubble({Key? key,
    required this.message,
    required this.time,
    required this.isUser,
    required this.delivered,
    required this.read,
    required this.isSelected,
    required this.uploaded,
    required this.downloaded, required this.senderUrl, required this.id, required this.chatId, required this.receiverUrl}) : super(key: key);
  final String message, time,senderUrl,id,chatId,receiverUrl;
  final bool isUser, delivered, read,isSelected,uploaded,downloaded;

  @override
  State<ImageBubble> createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble> {
  late Color bg;
  late CrossAxisAlignment align;
  late IconData icon;
  late BorderRadius radius;
  late bool uploaded;
  late bool downloaded;
  UploadTask? _uploadTask;
  DownloadTask? _downloadTask;
  late Color dbg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uploaded = widget.uploaded;
    downloaded=widget.downloaded;
     dbg=widget.isSelected?Colors.lightBlue.withOpacity(0.5): !widget.isUser ? Color.fromARGB(255, 72, 69, 69) : Color.fromARGB(255, 30, 75, 31);
    bg = widget.isSelected ? Colors.lightBlue.withOpacity(0.5) : !widget.isUser
        ? Colors.white
        : Colors.greenAccent.shade100;
    align = !widget.isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    icon = widget.read  ? Icons.done_all : Icons.done;
    radius = widget.isUser ? const BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    )
        : const BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    );
  }

  Future<String> uploadDocument(File doc) async {
    try {
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref(
          '/chatimage/${DateTime.now().microsecondsSinceEpoch}');
      _uploadTask = ref.putFile(doc);
      await Future.value(_uploadTask).catchError((e) => throw Exception('$e'));

      return ref.getDownloadURL().catchError((e) => throw Exception('$e'));
    } catch (e) {
      rethrow;
    }
  }

  Future<String> downloadImage(String imageUrl) async {
    try {

      final ref = firebase_storage.FirebaseStorage.instance.refFromURL(
          imageUrl);


      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/${DateTime.now()
          .microsecondsSinceEpoch}.jpg';

      _downloadTask = ref.writeToFile(File(tempPath));

      await Future.value(_downloadTask).catchError((e) =>
      throw Exception('$e'));
      ref.delete();
      return tempPath;
    } catch (e) {
      rethrow;
    }

  }
    bool downloading = false;
    bool isUploading = false;

    @override
    Widget build(BuildContext context) {
      return Container(
        color:(widget.isSelected)?Colors.blue.withOpacity(0.5):null,
        child: Column(
          crossAxisAlignment: align,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Builder(

              builder: (context) {
                final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                return Container(
                  constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7,
                      maxHeight: MediaQuery.of(context).size.height*0.4
                  ),
                  padding: const EdgeInsets.all(2),
                  margin: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: .5,
                        spreadRadius: 1.0,
                        color: Colors.black.withOpacity(.12))
                  ],

                  borderRadius: radius,
                  color:themeProvider.isDarkMode? dbg:bg,
        ),
                  child: Stack(
                      children: [ Container(
                          constraints:
                          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7,
                                  maxHeight: MediaQuery.of(context).size.height*0.4
                          ),

                        alignment: Alignment.bottomRight,
                        decoration: BoxDecoration(
                          image:(widget.isUser)? DecorationImage(
                            image: FileImage(File(widget.senderUrl)),
                            fit: BoxFit.cover
                          ):(downloaded)?DecorationImage(image: FileImage(File(widget.receiverUrl)),fit: BoxFit.cover)
                              :const DecorationImage(image: AssetImage('assets/blurimg.png')),

                          borderRadius: radius,

                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 55.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.time,
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              (widget.isUser) ? Icon(
                                icon,
                                size: 16,
                              ) : const SizedBox(width: 0,)
                            ],
                          ),
                        ),),
                        Center(child:
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:(widget.isUser)?(uploaded)?null:Colors.white.withOpacity(0.5):(downloaded)?null:Colors.white.withOpacity(0.5),
                          ),
                          child:(widget.isUser) ? (!isUploading&&!uploaded) ? IconButton(
                              onPressed: () async {
                                setState(() {
                                  isUploading = true;});
                                final docUrl = await uploadDocument(
                                    File(widget.senderUrl));
                                if (otherUserStream!.token != null && otherUserStream!.current!=widget.chatId && otherUserChat!.muted == false) {
                                      SendNotificationService().sendFCMChatMessage(
                                          otherUserStream!.token!,
                                          {'title': (otherUserChat!.displayName ?? curUser!.phoneNo), 'body': "Image"},
                                          {});
                                    }
                                String symmKeyString = (await const FlutterSecureStorage().read(key: widget.chatId))!;
                                encrypt.Key symmKey = encrypt.Key.fromBase64(symmKeyString);
                                encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(symmKey,padding: null));
                                encrypt.Encrypted encryptedDocUrl = encrypter.encrypt(docUrl,iv: iv);
                                String encryptedDocUrlString = encryptedDocUrl.base64;
                                ChatsRemoteServices().updateChatMessage(widget.chatId, {
                                  'uploaded': true,
                                  'text': encryptedDocUrlString
                                }, widget.id);
                                setState(() {
                                  uploaded = true;
                                });
                                }, icon: const Icon(Icons.upload))
                              : (!uploaded) ? progressIndicator(_uploadTask,null)
                              : const SizedBox(width: 0,) :
                          (!downloading && !downloaded)?IconButton(
                              onPressed: () async {
                                setState(() {
                                  downloading=true;
                                });
                                final receiveUrl=await downloadImage(widget.message);
                                ChatsRemoteServices().updateChatMessage(widget.chatId,
                                    {'receiverUrl':receiveUrl,
                                      'downloaded':true,
                                    }, widget.id);
                                setState(() {
                                  downloaded=true;});
                                }, icon: const Icon(Icons.download)):!downloaded?progressIndicator(null, _downloadTask):const SizedBox(width: 0,),
                        ),

                        )
                      ]
                  ),
                );
              }
            ),
          ],
        ),
      );
    }
  }



class MyBubble extends StatelessWidget {
  const MyBubble(
      {super.key, required this.message,
      required this.edited,
      required this.time,
      required this.delivered,
      required this.isUser,
      required this.read, required this.isSelected});

  final String message, time;
  final bool isUser, delivered, read, isSelected, edited;

  @override
  Widget build(BuildContext context) {
    final bg =isSelected?Colors.lightBlue.withOpacity(0.5): !isUser ? Colors.white : Colors.greenAccent.shade100;
    final dbg=isSelected?Colors.lightBlue.withOpacity(0.5): !isUser ? const Color.fromARGB(255, 72, 69, 69) : Color.fromARGB(255, 30, 75, 31);
    final align = !isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = read ? Icons.done_all : Icons.done;
    final radius = !isUser
        ? const BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: [
        Builder(
          builder: (context) {
            final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
            return Container(
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
              margin: const EdgeInsets.all(3.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                color:themeProvider.isDarkMode? dbg:bg,
                borderRadius: radius,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(message, style: const TextStyle(fontSize: 17)),
                  const SizedBox(
                    height: 1,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 55.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          time,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        (isUser)? Icon(
                          icon,
                          size: 16,
                        ):const SizedBox(width: 0,)
                      ],
                    ),
                  ),
                  const SizedBox(height: 1,),
                  (edited?Text("Edited",style: TextStyle(fontSize: 13),):SizedBox(height: 0,)),
                ],
              ),
            );
          }
        ),
      ],
    );
  }
}

class ChatWindow extends StatefulWidget {
  final String backgroundImage, otherUserId;
  final String? chatId;


  const ChatWindow({
    required this.otherUserId,
    this.backgroundImage =
        "assets/backgroundimage.png",
    this.chatId,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> with WidgetsBindingObserver{
  TextEditingController messageController = TextEditingController();
   //ScrollController scrollController= ScrollController();
  bool isTheOtherUserLoaded = false;
  String? chatid;
  int indexInContact=-1;
  bool isSending=false;
  bool blocked=false;
  bool done = false;
  bool isEditing=false;
  File? _image;
  List<bool> isSelected=[];
  List<int> otherUserChatSelected=[];
  int myMessageLength=0;
  int trueCount=0;
  List<int> unStarableSelected=[];
  List<ChatMessage> chatmessages=[];
  String backgroundImage ='';
  int unreadMessageCount=0;
  int ouumc=0;
   int bgIndex=-1;
  int fgIndex=0;

  bool assigned=false;
  late Users currentUser;
  bool youBlocked=false;
  bool otherBlocked=false;
  
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
  void getTheOtherUser(String id) async {
    otheruser = (await RemoteServices().getSingleUser(id))!;
    currentUser=(await RemoteServices().getSingleUser(cid))!;
    // otherUserChat=(await RemoteServices().getSingleUserChat(otheruser.id, '${otheruser.id}$cid'));
    // unreadMessageCount=otherUserChat?.unreadMessageCount??0;



    setState(() {
      isTheOtherUserLoaded = true;
      indexInContact=savedNumber.indexOf(otheruser.phoneNo);
      if(currentUser.blockedBy!=null && currentUser.blockedBy!.contains(widget.otherUserId) ){
        otherBlocked=true;
        hintText='You are blocked ';

      }
      if(otheruser.blockedBy!=null && otheruser.blockedBy!.contains(cid)){
        youBlocked=true;
        hintText='you have blocked';
      }
    });
  }
  String editingId='';
  String hintText='Type here ';

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    chatid = widget.chatId;
    getTheOtherUser(widget.otherUserId);
    backgroundImage=widget.backgroundImage;
    current=widget.chatId;


    super.initState();

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if (state == AppLifecycleState.resumed) {
      debugPrint("chat window resume");
      RemoteServices().updateUser(cid, {'current': current});
    }
    else {
      debugPrint("chat window exit");
      RemoteServices().updateUser(cid,{'current': null});
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isTheOtherUserLoaded == false
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : WillPopScope(
          onWillPop: () async {
            if(trueCount!=0){
            setState(() {
              trueCount=0;
              unStarableSelected=[];
              isSelected=List.filled(chatmessages.length, false);
              otherUserChatSelected=[];

            });
            return false;
          }else{
              return true;
            }
            },
          child: Scaffold(
              appBar: AppBar(
                elevation: .9,
               leading: (trueCount!=0)? IconButton(onPressed: (){
                setState(() {

                  isSelected=List.filled(chatmessages.length, false);
                  trueCount=0;
                  otherUserChatSelected=[];
                  unStarableSelected=[];
                });
                }, icon: const Icon(Icons.arrow_back)):const BackButton(),
                title:(trueCount!=0)?Row(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('$trueCount',),
                    ),
                    const Spacer(),
                    IconButton(onPressed: (){
                      showDialog(context: context, builder: (context)=>AlertDialog(
                        title: const Text('Delete message?',style: TextStyle(color: Colors.grey),),
                        actions: [
                          (otherUserChatSelected.isEmpty)?Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(onPressed: () async {
                                for (var i=chatmessages.length-1;i>=0;i-- ) {
                                  if(isSelected[i]) {
                                   ChatsRemoteServices().deleteSingleChatMessage(chatid!,chatmessages[i].id);
                                  }

                                }
                                setState(() {
                                 isSelected=List.filled(myMessageLength, false);
                                 trueCount=0;
                                 unStarableSelected=[];
                                 otherUserChatSelected=[];
                                });
                                Navigator.of(context,rootNavigator: true).pop();

                            },
                                child: const Text('Delete for Everyone',style: TextStyle(color: Colors.green),)),
                          ):const SizedBox(width: 0,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(onPressed: () async {
                              for(int i=0;i<chatmessages.length;i++){
                                if(isSelected[i]) {
                                  if (chatmessages[i].deletedForMe[widget
                                      .otherUserId] == null) {
                                    chatmessages[i].deletedForMe[cid] = true;
                                    ChatsRemoteServices().updateChatMessage(
                                        chatid!, {
                                      'deletedForMe': chatmessages[i].deletedForMe
                                    }, chatmessages[i].id);
                                  }
                                  else{
                                    ChatsRemoteServices().deleteSingleChatMessage(chatid!, chatmessages[i].id);
                                  }
                                }
                              }
                              setState(() {
                                isSelected=List.filled(myMessageLength, false);
                                trueCount=0;
                                unStarableSelected=[];
                                otherUserChatSelected=[];
                              });
                              Navigator.of(context,rootNavigator: true).pop();
                            }, child: const Text('Delete for Me',style: TextStyle(color: Colors.green),)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(onPressed: (){
                              Navigator.of(context,rootNavigator: true).pop();
                            }, child: const Text('Cancel',style: TextStyle(color: Colors.green),)),
                          ),

                        ],
                      ));
                    },
                        icon: const Icon(CupertinoIcons.delete)),
                    const SizedBox(width: 18,),

                    const SizedBox(width: 18,),
                    (trueCount==1 &&chatmessages[isSelected.indexOf(true)].contentType=='text' )?IconButton(onPressed: () async {
                     String?  symmKeyString = await const FlutterSecureStorage().read(key: chatid!);
                      encrypt.Key symmKey = encrypt.Key.fromBase64(symmKeyString!);
                      encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(symmKey,padding: null));
                      encrypt.Encrypted encryptedMessage = encrypt.Encrypted.fromBase64(chatmessages[isSelected.indexOf(true)].text);
                      final message = encrypter.decrypt(encryptedMessage,iv: iv);
                      await Clipboard.setData(ClipboardData(text: message));
                      setState(() {
                        isSelected=List.filled(chatmessages.length, false);
                        trueCount=0;
                        unStarableSelected=[];
                        otherUserChatSelected=[];
                      });
                    }, icon: const Icon(Icons.copy)):const SizedBox(width: 0,),

                  ],
                ) :Row(
                  children: [
                    InkWell(

                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.65,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                const SizedBox(
                                 width: 42.5,
                                 height: 40,
                                ),
                                CircleAvatar(
                                foregroundImage: NetworkImage((otherBlocked)?'http://ronaldmottram.co.nz/wp-content/uploads/2019/01/default-user-icon-8.jpg':otheruser.photoUrl!),
                              ),
                                (otherBlocked)?const SizedBox():Positioned(
                                  bottom: 1.5,
                                    right: 0,
                                    child: Container(
                                      height: 15,
                                  width: 15,
                                  decoration: BoxDecoration(
                                    color: (otherUserStream?.isOnline??false)?const Color.fromARGB(
                                        255, 0, 228, 31):Colors.white70,
                                    shape: BoxShape.circle
                                  ),
                                ))
                            ]
                            ),
                            const SizedBox(width: 10,),
                            SizedBox(
                              height: 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text((indexInContact!=-1)?savedUsers[indexInContact]:otheruser.phoneNo),
                                  (otherBlocked || otherUserStream==null)?const Text(''):Text((otherUserStream!.isOnline!)?'Online Now':'Last seen at ${otheruser.lastOnline?.hour}:${otheruser.lastOnline!.minute~/10}${otheruser.lastOnline!.minute%10} on ${otheruser.lastOnline!.day}/${otheruser.lastOnline!.month}/${otheruser.lastOnline!.year}'
                                    ,style: const TextStyle(fontSize: 10,fontWeight: FontWeight.w300),)
                                ],
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtherUserProfilePage(userId: widget.otherUserId,)));
                      },


                    ),
                    PopupMenuButton(itemBuilder: (context)=>
                    [
                      PopupMenuItem(
                          child:const Text('Clear chat'),
                      onTap: (){
                            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                              for(int i=0;i<chatmessages.length;i++){

                                  if (chatmessages[i].deletedForMe[widget
                                      .otherUserId] == null) {
                                    chatmessages[i].deletedForMe[cid] = true;
                                    ChatsRemoteServices().updateChatMessage(
                                        chatid!, {
                                      'deletedForMe': chatmessages[i].deletedForMe
                                    }, chatmessages[i].id);
                                  }
                                  else{
                                    ChatsRemoteServices().deleteSingleChatMessage(chatid!, chatmessages[i].id);
                                  }
                                }

                            });
                      },),
                      PopupMenuItem(child:  Text((otheruser.blockedBy!=null && otheruser.blockedBy!.contains(cid))?'Unblock':'Block'),
                      onTap: (){
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          if((otheruser.blockedBy!=null && otheruser.blockedBy!.contains(cid))){
                            otheruser.blockedBy!.remove(cid);
                            youBlocked=false;
                            hintText='Type here ';
                          }
                          else{
                            youBlocked=true;
                            hintText='You have blocked ';
                       if(otheruser.blockedBy!=null){ otheruser.blockedBy!.add(cid);}
                       else{
                        otheruser.blockedBy=[cid];
                        }}
                       RemoteServices().updateUser(widget.otherUserId, {'blockedBy':otheruser.blockedBy});
                         setState(() {

                         });
                        });
                      },
                      ),
                      PopupMenuItem(child: const Text('Change Wallpaper'),
                        onTap: (){
                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            SimpleDialog alert = SimpleDialog(
                              title: const Text("Choose an action"),
                              children: [
                                SimpleDialogOption(
                                  onPressed: () async {
                                    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                    if (image == null) {
                                      return;
                                    }
                                    final imageTemp = File(image.path);
                                    backgroundImage=imageTemp.path;
                                    RemoteServices().updateUserChat(cid, {'backgroundImage':backgroundImage}, '$cid${widget.otherUserId}');

                                    setState(() {

                                    });
                                    Navigator.of(context, rootNavigator: true).pop();
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
                                  onPressed: () async {
                                    final image = await ImagePicker().pickImage(source: ImageSource.camera);
                                    if (image == null) {
                                      return;
                                    }
                                    final imageTemp = File(image.path);
                                    backgroundImage=imageTemp.path;
                                    RemoteServices().updateUserChat(cid, {'backgroundImage':backgroundImage}, '$cid${widget.otherUserId}');

                                    setState(() {

                                    });
                                    Navigator.of(context, rootNavigator: true).pop();
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



                          });
                        },
                      )
                    ])
                  ],
                ),
                // actions: <Widget>[
                //
                // ],
              ),
              body: Builder(
                builder: (context) {
                  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                  return Container(
                    decoration: BoxDecoration(
                      image:!(backgroundImage=='assets/backgroundimage.png')? DecorationImage(
                        image:FileImage(File(backgroundImage)),
                        fit: BoxFit.cover,
                      ):DecorationImage(image: (themeProvider.isDarkMode?AssetImage('assets/backgroundimagedark.png'):AssetImage(backgroundImage)),
                        fit: BoxFit.cover
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 1,
                          child:StreamBuilder<Users>(
                            stream: RemoteServices().getUserStream(widget.otherUserId),
                            builder:( (context,snapshot){
                              if(snapshot.hasData){
                                if(snapshot.data?.isOnline != otherUserStream?.isOnline || snapshot.data?.current!=otherUserStream?.current) {

                                  otherUserStream = snapshot.data;
                                  WidgetsBinding.instance.addPostFrameCallback((
                                      timeStamp) {
                                        debugPrint("That set state");
                                    setState(() {
                                    });
                                  });
                                }
                              }
                              return const SizedBox();
                            }),
                          ) ,
                        ),
                        Flexible(
                          child: StreamBuilder<List<ChatMessage>>(
                            stream: (chatid == null
                                ? null
                                : ChatsRemoteServices().getChatMessages(chatid!)),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {


                                 chatmessages = snapshot.data!.reversed.toList();

                                if(myMessageLength!=chatmessages.length){
                                  myMessageLength=chatmessages.length;
                                  isSelected=List.filled(myMessageLength, false);
                                  RemoteServices().updateUserChat(cid,{'unreadMessageCount':0} , '$cid${otheruser.id}');

                                  trueCount=0;
                                  bgIndex=0;
                                  if(!assigned){
                                    assigned=true;
                                    bgIndex=-1;
                                  }

                                }
                                while(fgIndex<chatmessages.length && !chatmessages[fgIndex].read){
                                  if(chatmessages[fgIndex].senderId!=cid) {
                                    debugPrint("chat window read true 1");
                                    ChatsRemoteServices().updateChatMessage(chatid!, {'read':true}, chatmessages[fgIndex].id);
                                  }
                                  fgIndex++;

                                }
                                //fgIndex=chatmessages.length;
                                while(bgIndex>=0){
                                  if(chatmessages[bgIndex].senderId==cid){
                                    ouumc++;

                                  }
                                  else{
                                    debugPrint("chat window read true 2");
                                    ChatsRemoteServices().updateChatMessage(chatid!,{'read':true}, chatmessages[bgIndex].id);

                                  }
                                  bgIndex--;

                                }



                                // RemoteServices().updateUserChat(otheruser.id,{'unreadMessageCount':unreadMessageCount+ouumc} , '${otheruser.id}$cid');
                                // debugPrint('unread${unreadMessageCount+ouumc}');
                                // return ListView.builder(
                                //   itemCount: chatmessages.length,
                                //   itemBuilder: (context, index) {
                                //     final ChatMessage chatmessage = chatmessages[index];
                                //     final docRef = FirebaseFirestore.instance.collection("chats").doc(chatmessage.id);
                                //     docRef.snapshots(includeMetadataChanges: true).listen((event) async{
                                //       if(chatmessage.delivered==false){
                                //         if(!event.metadata.hasPendingWrites){
                                //           chatmessage.delivered = true;
                                //           await FirebaseFirestore.instance.collection("chats/$chatid/chatMessages").doc(chatmessage.id).update({"delivered":true});
                                //         }
                                //       }
                                //     });
                                //     return MyBubble(message: chatmessage.text, time: ("${chatmessage.timestamp.hour}:${chatmessage.timestamp.minute}"), delivered: chatmessage.delivered, isUser: (chatmessage.senderId==cid), read: chatmessage.read);
                                //   },
                                // );



                                //   Widget listBuilder=ListView.builder(
                                //   controller: scrollController,
                                //   itemCount: chatmessages.length,
                                //   itemBuilder: (context, index) {
                                //     final ChatMessage chatmessage = chatmessages[index];
                                //     if (chatmessage.deletedForMe[cid] == null && chatmessage.deletedForEveryone == false) {
                                //       return MyBubble(
                                //           message: chatmessage.text,
                                //           time:
                                //               ("${chatmessage.timestamp.hour}:${chatmessage.timestamp.minute~/10}${chatmessage.timestamp.minute%10}"),
                                //           delivered: chatmessage.delivered,
                                //           isUser: (chatmessage.senderId == cid),
                                //           read: chatmessage.read);
                                //     } else {
                                //       return const SizedBox(
                                //         height: 0,
                                //       );
                                //     }
                                //   },
                                // );

                                return StreamBuilder<UserChat>(
                                  stream: RemoteServices().getUserChatStream(otheruser.id, '${otheruser.id}$cid'),
                                    builder: (context,snapshot){
                                    if(snapshot.hasData){
                                      otherUserChat=snapshot.data;
                                      unreadMessageCount=otherUserChat?.unreadMessageCount??0;
                                      if(ouumc!=0) {
                                        debugPrint("chat window umc + ouumc");
                                        RemoteServices().updateUserChat(widget.otherUserId,
                                          {'unreadMessageCount':unreadMessageCount+ouumc}, '${otherUserChat?.id}');
                                      }
                                      ouumc=0;
                                      //debugPrint('$ouumc');
                                    }
                                    Widget listBuilder=ListView.builder(
                                      //controller: scrollController,
                                      reverse: true,
                                      itemCount: chatmessages.length,
                                      itemBuilder: (context, index) {
                                        final ChatMessage chatmessage = chatmessages[index];
                                        if (chatmessage.deletedForMe[cid] == null && chatmessage.deletedForEveryone == false) {
                                          String? symmKeyString;
                                          return FutureBuilder(
                                            future: const FlutterSecureStorage().read(key: chatid!),
                                            builder: (context, snapshot) {
                                              String message='';
                                              if(snapshot.hasData){
                                                if(chatmessage.text!='')
                                                {symmKeyString = snapshot.data;
                                                encrypt.Key symmKey = encrypt.Key.fromBase64(symmKeyString!);
                                                encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(symmKey,padding: null));
                                                encrypt.Encrypted encryptedMessage = encrypt.Encrypted.fromBase64(chatmessage.text);
                                                message = encrypter.decrypt(encryptedMessage,iv: iv);}
                                                // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                                //   scrollController.animateTo(
                                                //     scrollController.position.maxScrollExtent + 60,
                                                //     duration: const Duration(milliseconds: 300),
                                                //     curve: Curves.easeOut,
                                                //   );
                                                //   debugPrint('done dona-done');
                                                // }) ;


                                                debugPrint("Chat window future builder");
                                                return GestureDetector(

                                                  child:(chatmessage.contentType=='text')?MyBubble(
                                                    message: message,
                                                    edited: chatmessage.edited,
                                                    time:
                                                    ("${chatmessage.timestamp.hour}:${chatmessage.timestamp.minute~/10}${chatmessage.timestamp.minute%10}"),
                                                    delivered: chatmessage.delivered,
                                                    isUser: (chatmessage.senderId == cid),
                                                    read: chatmessage.read,
                                                    isSelected: isSelected[index],
                                                  ):
                                                  (chatmessage.contentType=='image')?(chatmessage.uploaded)?
                                                  ImageBubble(message:message,
                                                      time: ("${chatmessage.timestamp.hour}:${chatmessage.timestamp.minute~/10}${chatmessage.timestamp.minute%10}"),
                                                      isUser: (cid==chatmessage.senderId),
                                                      delivered: chatmessage.delivered, read: chatmessage.read,
                                                      isSelected: isSelected[index],
                                                      uploaded: chatmessage.uploaded,
                                                      downloaded: chatmessage.downloaded,
                                                      senderUrl: chatmessage.senderUrl??'', id: chatmessage.id,
                                                      chatId: chatid!, receiverUrl: chatmessage.receiverUrl??''):
                                                  (cid==chatmessage.senderId)?ImageBubble(message:message,
                                                      time: ("${chatmessage.timestamp.hour}:${chatmessage.timestamp.minute~/10}${chatmessage.timestamp.minute%10}"),
                                                      isUser: (cid==chatmessage.senderId),
                                                      delivered: chatmessage.delivered, read: chatmessage.read,
                                                      isSelected: isSelected[index],
                                                      uploaded: chatmessage.uploaded,
                                                      downloaded: chatmessage.downloaded,
                                                      senderUrl: chatmessage.senderUrl??'', id: chatmessage.id,
                                                      chatId: chatid!, receiverUrl: chatmessage.receiverUrl??''):const SizedBox(height: 0,):
                                                  (chatmessage.uploaded)?DocBuble(message: message,
                                                      time: ("${chatmessage.timestamp.hour}:${chatmessage.timestamp.minute~/10}${chatmessage.timestamp.minute%10}")
                                                      , senderUrl: chatmessage.senderUrl??'',
                                                      id: chatmessage.id,
                                                      chatId: chatid!,
                                                      receiverUrl: chatmessage.receiverUrl??'',
                                                      isUser: (cid==chatmessage.senderId),
                                                      delivered: chatmessage.delivered,
                                                      read: chatmessage.read,
                                                      isSelected: isSelected[index], uploaded: chatmessage.uploaded,
                                                      downloaded: chatmessage.downloaded, contentType: chatmessage.contentType)
                                                      :(cid==chatmessage.senderId)?
                                                  DocBuble(message: message,
                                                      time: ("${chatmessage.timestamp.hour}:${chatmessage.timestamp.minute~/10}${chatmessage.timestamp.minute%10}")
                                                      , senderUrl: chatmessage.senderUrl??'',
                                                      id: chatmessage.id,
                                                      chatId: chatid!,
                                                      receiverUrl: chatmessage.receiverUrl??'',
                                                      isUser: (cid==chatmessage.senderId),
                                                      delivered: chatmessage.delivered,
                                                      read: chatmessage.read,
                                                      isSelected: isSelected[index], uploaded: chatmessage.uploaded,
                                                      downloaded: chatmessage.downloaded, contentType: chatmessage.contentType)
                                                      :const SizedBox(height: 0,)
                                                  ,
                                                  onTap: () {

                                                    if (trueCount != 0) {
                                                      setState(() {


                                                        if (isSelected[index]) {
                                                          isSelected[index] = false;
                                                          trueCount--;
                                                          if(chatmessage.senderId!=cid){
                                                            otherUserChatSelected.remove(index);
                                                          }
                                                          if(chatmessage.contentType!='text'){
                                                            if(chatmessage.senderId!=cid){
                                                              if(!chatmessage.downloaded){
                                                                unStarableSelected.remove(index);
                                                              }
                                                            }
                                                          }
                                                        }
                                                        else {
                                                          trueCount++;
                                                          isSelected[index] = true;
                                                          if(chatmessage.senderId!=cid){
                                                            otherUserChatSelected.add(index);
                                                          }
                                                          if(chatmessage.contentType!='text'){
                                                            if(chatmessage.senderId!=cid){
                                                              if(!chatmessage.downloaded){
                                                                unStarableSelected.add(index);
                                                              }
                                                            }
                                                          }
                                                        } });
                                                    }
                                                    else if(cid==chatmessage.senderId  && chatmessage.contentType=='text' && !chatmessage.edited){
                                                          SimpleDialog alert=SimpleDialog(
                                                            children: [
                                                              SimpleDialogOption(
                                                                child: const Row(
                                                                  children: [
                                                                    Icon(Icons.edit),
                                                                    Text('edit message'),
                                                                  ],
                                                                ),
                                                                onPressed: (){

                                                                  setState(() {
                                                                    isEditing=true;
                                                                    messageController.text=message;
                                                                    editingId=chatmessage.id;
                                                                  });
                                                                  Navigator.of(context,rootNavigator: true).pop();
                                                                },
                                                              )


                                                            ],
                                                          ) ;
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) => alert,
                                                            barrierDismissible: true,
                                                          );
                                                    }
                                                  },
                                                  onLongPress: (){
                                                    setState(() {
                                                      if(isSelected[index]){
                                                        isSelected[index]=false;
                                                        trueCount--;
                                                        if(chatmessage.senderId!=cid){
                                                          otherUserChatSelected.remove(index);
                                                        }
                                                        if(chatmessage.contentType!='text'){
                                                          if(chatmessage.senderId!=cid){
                                                            if(!chatmessage.downloaded){
                                                              unStarableSelected.remove(index);
                                                            }
                                                          }
                                                        }
                                                      }
                                                      else{
                                                        trueCount++;
                                                        isSelected[index]=true;
                                                        if(chatmessage.senderId!=cid){
                                                          otherUserChatSelected.add(index);
                                                        }
                                                        if(chatmessage.contentType!='text'){
                                                          if(chatmessage.senderId!=cid){
                                                            if(!chatmessage.downloaded){
                                                              unStarableSelected.add(index);
                                                            }
                                                          }
                                                        }
                                                      }
                                                    });
                                                  },);

                                              }
                                              else if(snapshot.hasError){
                                                throw Exception('symmKey not found. or ${snapshot.error}');
                                              }
                                              else{
                                                // throw Exception("symmKey not found.");
                                                return const SizedBox(
                                                  height: 0,
                                                );
                                              }
                                            },
                                            // (chatmessage) != null?(chatmessage.contentType=='image')?
                                            // ImageBubble(message: chatmessage.text,
                                            //     time:("${chatmessage.timestamp.hour}:${chatmessage.timestamp.minute~/10}${chatmessage.timestamp.minute%10}"),
                                            //     isUser: cid==chatmessage.senderId,
                                            //     delivered: chatmessage.delivered, read: chatmessage.read, isSelected: isSelected[index],
                                            //     uploaded: chatmessage.uploaded, downloaded: chatmessage.downloaded,
                                            //     senderUrl: chatmessage.senderUrl!, id: chatmessage.id,
                                            //     chatId: chatid!, receiverUrl: chatmessage.receiverUrl??''):SizedBox():SizedBox(),

                                          );
                                        } else {
                                          return const SizedBox(
                                            height: 0,
                                          );
                                        }
                                      },
                                    );

                                    return listBuilder;
                                    }
                                );


                              } else {
                                return const Center(child: Text("No conversations yet."));
                              }
                            },
                          ),
                        ),
                        // (youBlocked)?const Center(
                        //   child: Text('you have blocked this chat unblock to continue !'),
                        // ):(otherBlocked)?Center(child: Text('${savedUsers[savedNumber.indexOf(otheruser.phoneNo)]} has blocked you !'),):const SizedBox(height: 0,),
                        Builder(
                          builder: (context) {
                            final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                            return Container(
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.95),
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: (themeProvider.isDarkMode?Color.fromARGB(255, 72, 69, 69):Colors.white),
                                borderRadius: BorderRadius.circular(24.0),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(
                                        minHeight: 0,
                                        maxHeight: 153,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: TextField(
                                          style: const TextStyle(fontSize: 19),
                                          maxLines: null,
                                        //  readOnly: (youBlocked ||otherBlocked),
                                          controller: messageController,
                                          onChanged: (e){
                                            debugPrint("chat window sus set state");
                                            setState(() {

                                            });
                                            // if(messageController.text.length ==1||messageController.text.length==2 || messageController.text.isEmpty){
                                            //   setState(() {
                                            //
                                            //   });
                                            // }
                                          },

                                          decoration: const InputDecoration(
                                            hintText: 'Type here',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Transform.rotate(angle: math.pi/7,
                                    child: const Icon(Icons.attach_file)),
                                    onPressed: () {
                                      SimpleDialog alert = SimpleDialog(
                                        title: const Text("Choose an action"),
                                        children: [
                                          SimpleDialogOption(
                                            onPressed: () async {
                                              final files=await ChatsRemoteServices().pickDocument();
                                              Navigator.of(context,rootNavigator: true).pop();
                                              if(files!=null){

                                                if (chatid == null) {
                                                  await ChatsRemoteServices().setChat(Chat(
                                                    id: "$cid${otheruser.id}",
                                                    participantIds: [cid, otheruser.id],
                                                  ));
                                                  await RemoteServices().setUserChat(
                                            cid,
                                            UserChat(
                                                id: "$cid${widget.otherUserId}",
                                                chatId: "$cid${widget.otherUserId}",
                                                recipientPhoto: otheruser.photoUrl!,
                                                pinned: false,
                                                recipientPhoneNo: otheruser.phoneNo,
                                                backgroundImage: "assets/backgroundimage.png",
                                                lastMessageTime: DateTime.now(),
                                                ));
                                        encrypt.Key symmKey = encrypt.Key.fromSecureRandom(32);
                                        String symmKeyString = symmKey.base64;
                                        RSAPublicKey publicKey = rsa.RsaKeyHelper().parsePublicKeyFromPem(otheruser.publicKey);
                                        encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: publicKey));
                                        encrypt.Encrypted encryptedSymmKey = encrypter.encrypt(symmKeyString);
                                        String encrytedSymmKeyString = encryptedSymmKey.base64;
                                        final Users currentuser =
                                            (await RemoteServices().getSingleUser(cid))!;
                                        await RemoteServices().setUserChat(
                                            otheruser.id,
                                            UserChat(
                                                id: "${widget.otherUserId}$cid",
                                                chatId: "$cid${widget.otherUserId}",
                                                recipientPhoto: currentuser.photoUrl!,
                                                pinned: false,
                                                recipientPhoneNo: currentuser.phoneNo,
                                                backgroundImage: "assets/backgroundimage.png",
                                                containsSymmKey: encrytedSymmKeyString,
                                              lastMessageTime: DateTime.now(),
                                                ));
                                                otherUserChat = UserChat(
                                                id: "${widget.otherUserId}$cid",
                                                chatId: "$cid${widget.otherUserId}",
                                                recipientPhoto: currentuser.photoUrl!,
                                                pinned: false,
                                                recipientPhoneNo: currentuser.phoneNo,
                                                backgroundImage: "assets/backgroundimage.png",
                                                containsSymmKey: encrytedSymmKeyString,
                                              lastMessageTime: DateTime.now(),
                                                );
                                        await const FlutterSecureStorage().write(key: "$cid${widget.otherUserId}",value: symmKeyString);
                                                  setState(() {
                                                  chatid = "$cid${otheruser.id}";
                                                });
                                                }
                                                await RemoteServices().setUserChat(
                                                    cid,
                                                    UserChat(
                                                      id: "$cid${otheruser.id}",
                                                      chatId: chatid!,
                                                      recipientPhoto: otheruser.photoUrl!,
                                                      pinned: false,
                                                      recipientPhoneNo:otheruser.phoneNo,
                                                      backgroundImage: "assets/backgroundimage.png",
                                                      lastMessageTime: DateTime.now(),
                                                    ));
                                                final Users currentuser =
                                                (await RemoteServices().getSingleUser(cid))!;
                                                otherUserChat=UserChat(
                                                    id: "${otheruser.id}$cid",
                                                    chatId: chatid!,
                                                    recipientPhoto: currentuser.photoUrl!,
                                                    pinned: false,
                                                    recipientPhoneNo: currentuser.phoneNo,
                                                    backgroundImage: "assets/backgroundimage.png",
                                                    lastMessageTime: DateTime.now()
                                                );
                                                await RemoteServices().setUserChat(
                                                   otheruser.id,
                                                  otherUserChat!
                                                    );





                                                //     if(!done){
                                                //  final docsnap = await FirebaseFirestore.instance.collection('users').doc(widget.otheruser.id).collection('userChats').doc("${widget.otheruser.id}$cid").get();
                                                //   if(!docsnap.exists){
                                                //     final Users currentuser = (await RemoteServices().getSingleUser(cid))!;
                                                //     await RemoteServices().setUserChat(widget.otheruser.id,
                                                //         UserChat(id: "${widget.otheruser.id}$cid", chatId: chatid!, recipientPhoto: currentuser.photoUrl!, pinned: false, recipientPhoneNo: currentuser.phoneNo)
                                                //     );
                                                //   }
                                                // }





                                                for (int i = 0; i < files.files.length; i++) {
                                                  // firebase_storage.Reference ref =
                                                  // firebase_storage.FirebaseStorage.instance.ref(
                                                  //     '/documents/${DateTime.now().microsecondsSinceEpoch}');
                                                  // uploadTask.add(ref.putFile(File(widget.result.files[i]
                                                  //     .path!)));
                                                  // await Future.value(uploadTask);
                                                  //
                                                  // final docUrl=await ref.getDownloadURL();
                                                  await ChatsRemoteServices().setChatMessage(
                                                      chatid!,
                                                      ChatMessage(
                                                          id: "${DateTime.now().microsecondsSinceEpoch}",
                                                          senderId: cid,
                                                          text: '',
                                                          contentType: "document ${files.files[i].name}",
                                                          timestamp: DateTime.now(),
                                                          senderUrl: files.paths[i]!));

                                                }
                                                // DocumentSnapshot docsnap = await FirebaseFirestore.instance
                                                //     .collection('users').doc(cid).collection('userChats').doc("$cid${widget.otheruser.id}").get();
                                                // if(!docsnap.exists){
                                                //   await RemoteServices().setUserChat(cid,
                                                //       UserChat(id: "$cid${widget.otheruser.id}", chatId: chatid!, recipientPhoto: widget.otheruser.photoUrl!, pinned: false, recipientPhoneNo: widget.otheruser.phoneNo,)
                                                //   );
                                                //
                                                // }
                                                  //debugPrint(' printing filels   ${files}');
                                                RemoteServices().updateUserChat(
                                                    cid,
                                                    {
                                                      'lastMessage': (files.files[files.files.length-1].name.length >
                                                          100)
                                                          ?files.files[files.files.length-1].name.substring(0, 100)
                                                          : files.files[files.files.length-1].name,
                                                      'lastMessageType': "document",
                                                      'lastMessageTime': DateTime.now().toIso8601String(),
                                                      'isSender':true
                                                    },
                                                    "$cid${otheruser.id}");
                                                RemoteServices().updateUserChat(
                                                    widget.otherUserId,
                                                    {
                                                      'lastMessage': (files.files[files.files.length-1].name.length >
                                                          100)
                                                          ?files.files[files.files.length-1].name.substring(0, 100)
                                                          : files.files[files.files.length-1].name,
                                                      'lastMessageType': "document",
                                                      'lastMessageTime': DateTime.now().toIso8601String(),
                                                      'isSender':false
                                                    },
                                                    "${widget.otherUserId}$cid");

                                               }

                                            },
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.doc,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  "Send document",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SimpleDialogOption(
                                            onPressed: () async {
                                              await getImage(ImageSource.camera);
                                              if(_image!=null){

                                                if (chatid == null) {
                                                  await ChatsRemoteServices().setChat(Chat(
                                                    id: "$cid${otheruser.id}",
                                                    participantIds: [cid, otheruser.id],
                                                  ));
                                                  await RemoteServices().setUserChat(
                                            cid,
                                            UserChat(
                                                id: "$cid${widget.otherUserId}",
                                                chatId: "$cid${widget.otherUserId}",
                                                recipientPhoto: otheruser.photoUrl!,
                                                pinned: false,
                                                recipientPhoneNo: otheruser.phoneNo,
                                                backgroundImage: "assets/backgroundimage.png",
                                              lastMessageTime: DateTime.now()
                                                ));
                                        encrypt.Key symmKey = encrypt.Key.fromSecureRandom(32);
                                        String symmKeyString = symmKey.base64;
                                        RSAPublicKey publicKey = rsa.RsaKeyHelper().parsePublicKeyFromPem(otheruser.publicKey);
                                        encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: publicKey));
                                        encrypt.Encrypted encryptedSymmKey = encrypter.encrypt(symmKeyString);
                                        String encrytedSymmKeyString = encryptedSymmKey.base64;
                                        final Users currentuser =
                                            (await RemoteServices().getSingleUser(cid))!;
                                        otherUserChat=UserChat(
                                          id: "${widget.otherUserId}$cid",
                                          chatId: "$cid${widget.otherUserId}",
                                          recipientPhoto: currentuser.photoUrl!,
                                          pinned: false,
                                          recipientPhoneNo: currentuser.phoneNo,
                                          backgroundImage: "assets/backgroundimage.png",
                                          containsSymmKey: encrytedSymmKeyString,
                                          lastMessageTime:DateTime.now(),
                                        );
                                        await RemoteServices().setUserChat(
                                            otheruser.id,
                                          otherUserChat!
                                            );
                                        await const FlutterSecureStorage().write(key: "$cid${widget.otherUserId}",value: symmKeyString);
                                                  setState(() {
                                              chatid = "$cid${otheruser.id}";
                                              });
                                                }
                                                await RemoteServices().setUserChat(
                                                    cid,
                                                    UserChat(
                                                      id: "$cid${otheruser.id}",
                                                      chatId: chatid!,
                                                      recipientPhoto: otheruser.photoUrl!,
                                                      pinned: false,
                                                      recipientPhoneNo:otheruser.phoneNo,
                                                      backgroundImage: "assets/backgroundimage.png",
                                                      lastMessageTime: DateTime.now()
                                                    ));
                                                final Users currentuser =
                                                (await RemoteServices().getSingleUser(cid))!;

                                                otherUserChat=UserChat(
                                                  id: "${widget.otherUserId}$cid",
                                                  chatId: "$cid${widget.otherUserId}",
                                                  recipientPhoto: currentuser.photoUrl!,
                                                  pinned: false,
                                                  recipientPhoneNo: currentuser.phoneNo,
                                                  backgroundImage: "assets/backgroundimage.png",
                                                 // containsSymmKey: encrytedSymmKeyString,
                                                  lastMessageTime:DateTime.now(),
                                                );
                                                await RemoteServices().setUserChat(
                                                    otheruser.id,
                                                    otherUserChat!
                                                );






                                              //     if(!done){
                                              //  final docsnap = await FirebaseFirestore.instance.collection('users').doc(widget.otheruser.id).collection('userChats').doc("${widget.otheruser.id}$cid").get();
                                              //   if(!docsnap.exists){
                                              //     final Users currentuser = (await RemoteServices().getSingleUser(cid))!;
                                              //     await RemoteServices().setUserChat(widget.otheruser.id,
                                              //         UserChat(id: "${widget.otheruser.id}$cid", chatId: chatid!, recipientPhoto: currentuser.photoUrl!, pinned: false, recipientPhoneNo: currentuser.phoneNo)
                                              //     );
                                              //   }
                                              // }





                                              for (int i = 0; i < 1; i++) {
                                              // firebase_storage.Reference ref =
                                              // firebase_storage.FirebaseStorage.instance.ref(
                                              //     '/documents/${DateTime.now().microsecondsSinceEpoch}');
                                              // uploadTask.add(ref.putFile(File(widget.result.files[i]
                                              //     .path!)));
                                              // await Future.value(uploadTask);
                                              //
                                              // final docUrl=await ref.getDownloadURL();
                                              await ChatsRemoteServices().setChatMessage(
                                              chatid!,
                                              ChatMessage(
                                              id: "${DateTime.now().microsecondsSinceEpoch}",
                                              senderId: cid,
                                              text: '',
                                              contentType: "image",
                                              timestamp: DateTime.now(),
                                              senderUrl: _image!.path));

                                              }
                                              // DocumentSnapshot docsnap = await FirebaseFirestore.instance
                                              //     .collection('users').doc(cid).collection('userChats').doc("$cid${widget.otheruser.id}").get();
                                              // if(!docsnap.exists){
                                              //   await RemoteServices().setUserChat(cid,
                                              //       UserChat(id: "$cid${widget.otheruser.id}", chatId: chatid!, recipientPhoto: widget.otheruser.photoUrl!, pinned: false, recipientPhoneNo: widget.otheruser.phoneNo,)
                                              //   );
                                              //
                                              // }

                                              RemoteServices().updateUserChat(
                                              cid,
                                              {
                                              'lastMessage': 'Image',
                                              'lastMessageType': "image",
                                              'lastMessageTime': DateTime.now().toIso8601String(),
                                                'isSender':true,
                                              },"$cid${otheruser.id}"

                                              );

                                                    RemoteServices().updateUserChat(
                                                    widget.otherUserId,
                                                    {
                                                      'lastMessage': 'Image',
                                                      'lastMessageType': "image",
                                                      'lastMessageTime': DateTime.now().toIso8601String(),
                                                      'issender':false,
                                                    },
                                                    "${widget.otherUserId}$cid");
                                                    _image=null;
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
                                                  "send from camera",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SimpleDialogOption(
                                            onPressed: () async {
                                              await getImage(ImageSource.gallery);
                                              if(_image!=null){

                                                if (chatid == null) {
                                                  await ChatsRemoteServices().setChat(Chat(
                                                    id: "$cid${otheruser.id}",
                                                    participantIds: [cid, otheruser.id],
                                                  ));
                                                  await RemoteServices().setUserChat(
                                            cid,
                                            UserChat(
                                                id: "$cid${widget.otherUserId}",
                                                chatId: "$cid${widget.otherUserId}",
                                                recipientPhoto: otheruser.photoUrl!,
                                                pinned: false,
                                                recipientPhoneNo: otheruser.phoneNo,
                                                backgroundImage: "assets/backgroundimage.png",
                                              lastMessageTime: DateTime.now()
                                                ));
                                        encrypt.Key symmKey = encrypt.Key.fromSecureRandom(32);
                                        String symmKeyString = symmKey.base64;
                                        RSAPublicKey publicKey = rsa.RsaKeyHelper().parsePublicKeyFromPem(otheruser.publicKey);
                                        encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.RSA(publicKey: publicKey));
                                        encrypt.Encrypted encryptedSymmKey = encrypter.encrypt(symmKeyString);
                                        String encrytedSymmKeyString = encryptedSymmKey.base64;
                                        final Users currentuser =
                                            (await RemoteServices().getSingleUser(cid))!;

                                                  otherUserChat=UserChat(
                                                    id: "${widget.otherUserId}$cid",
                                                    chatId: "$cid${widget.otherUserId}",
                                                    recipientPhoto: currentuser.photoUrl!,
                                                    pinned: false,
                                                    recipientPhoneNo: currentuser.phoneNo,
                                                    backgroundImage: "assets/backgroundimage.png",
                                                    containsSymmKey: encrytedSymmKeyString,
                                                    lastMessageTime:DateTime.now(),
                                                  );
                                                  await RemoteServices().setUserChat(
                                                      otheruser.id,
                                                      otherUserChat!
                                                  );
                                        await const FlutterSecureStorage().write(key: "$cid${widget.otherUserId}",value: symmKeyString);
                                                  setState(() {
                                                  chatid = "$cid${otheruser.id}";
                                                });
                                                }
                                                await RemoteServices().setUserChat(
                                                    cid,
                                                    UserChat(
                                                      id: "$cid${otheruser.id}",
                                                      chatId: chatid!,
                                                      recipientPhoto: otheruser.photoUrl!,
                                                      pinned: false,
                                                      recipientPhoneNo:otheruser.phoneNo,
                                                      backgroundImage: "assets/backgroundimage.png",
                                                      lastMessageTime: DateTime.now()
                                                    ));
                                                final Users currentuser =
                                                (await RemoteServices().getSingleUser(cid))!;
                                                otherUserChat=UserChat(
                                                  id: "${widget.otherUserId}$cid",
                                                  chatId: "$cid${widget.otherUserId}",
                                                  recipientPhoto: currentuser.photoUrl!,
                                                  pinned: false,
                                                  recipientPhoneNo: currentuser.phoneNo,
                                                  backgroundImage: "assets/backgroundimage.png",
                                                  //containsSymmKey: encrytedSymmKeyString,
                                                  lastMessageTime:DateTime.now(),
                                                );
                                                await RemoteServices().setUserChat(
                                                    otheruser.id,
                                                    otherUserChat!
                                                );






                                                //     if(!done){
                                                //  final docsnap = await FirebaseFirestore.instance.collection('users').doc(widget.otheruser.id).collection('userChats').doc("${widget.otheruser.id}$cid").get();
                                                //   if(!docsnap.exists){
                                                //     final Users currentuser = (await RemoteServices().getSingleUser(cid))!;
                                                //     await RemoteServices().setUserChat(widget.otheruser.id,
                                                //         UserChat(id: "${widget.otheruser.id}$cid", chatId: chatid!, recipientPhoto: currentuser.photoUrl!, pinned: false, recipientPhoneNo: currentuser.phoneNo)
                                                //     );
                                                //   }
                                                // }





                                                for (int i = 0; i < 1; i++) {
                                                  // firebase_storage.Reference ref =
                                                  // firebase_storage.FirebaseStorage.instance.ref(
                                                  //     '/documents/${DateTime.now().microsecondsSinceEpoch}');
                                                  // uploadTask.add(ref.putFile(File(widget.result.files[i]
                                                  //     .path!)));
                                                  // await Future.value(uploadTask);
                                                  //
                                                  // final docUrl=await ref.getDownloadURL();
                                                  await ChatsRemoteServices().setChatMessage(
                                                      chatid!,
                                                      ChatMessage(
                                                          id: "${DateTime.now().microsecondsSinceEpoch}",
                                                          senderId: cid,
                                                          text: '',
                                                          contentType: "image",
                                                          timestamp: DateTime.now(),
                                                          senderUrl: _image!.path));

                                                }
                                                // DocumentSnapshot docsnap = await FirebaseFirestore.instance
                                                //     .collection('users').doc(cid).collection('userChats').doc("$cid${widget.otheruser.id}").get();
                                                // if(!docsnap.exists){
                                                //   await RemoteServices().setUserChat(cid,
                                                //       UserChat(id: "$cid${widget.otheruser.id}", chatId: chatid!, recipientPhoto: widget.otheruser.photoUrl!, pinned: false, recipientPhoneNo: widget.otheruser.phoneNo,)
                                                //   );
                                                //
                                                // }

                                                RemoteServices().updateUserChat(
                                                    cid,
                                                    {
                                                      'lastMessage': 'Image',
                                                      'lastMessageType': "image",
                                                      'lastMessageTime': DateTime.now().toIso8601String(),
                                                      'isSender':true,
                                                    },"$cid${otheruser.id}"

                                                );

                                                RemoteServices().updateUserChat(
                                                    widget.otherUserId,
                                                    {
                                                      'lastMessage': 'Image',
                                                      'lastMessageType': "image",
                                                      'lastMessageTime': DateTime.now().toIso8601String(),
                                                      'isSender':false
                                                    },
                                                    "${widget.otherUserId}$cid");
                                                _image=null;
                                              }

                                            },
                                            child: const Row(
                                              children: [
                                                Icon(
                                                  CupertinoIcons.photo,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(width: 8.0),
                                                Text(
                                                  "Send image from gallery",
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
                                  ),
                                  (messageController.text.isEmpty || isSending)?const SizedBox(width: 0,):IconButton(
                                    iconSize: (24.0),
                                    onPressed: () async {
                                      if(youBlocked){
                                        ScaffoldMessenger.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(SnackBar(content: Text('You have blocked ${(savedNumber.contains(otheruser.phoneNo))?savedUsers[savedNumber.indexOf(otheruser.phoneNo)]:otheruser.phoneNo} unblock to continue chat')));
                                      }
                                      else if(otherBlocked){
                                        ScaffoldMessenger.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(SnackBar(content: Text('${(savedNumber.contains(otheruser.phoneNo))?savedUsers[savedNumber.indexOf(otheruser.phoneNo)]:otheruser.phoneNo} has blocked you so can not continue chat')));
                                      }
                                      else {
                                        debugPrint("Chat window set state true");
                                        setState(() {
                                          isSending = true;
                                        });
                                        String temp = messageController.text;
                                        messageController.clear();
                                        if (!isEditing) {
                                          if (chatid == null) {
                                            await ChatsRemoteServices().setChat(Chat(
                                              id: "$cid${widget.otherUserId}",
                                              participantIds: [cid, widget.otherUserId],
                                            ));
                                            await RemoteServices().setUserChat(
                                                cid,
                                                UserChat(
                                                  id: "$cid${widget.otherUserId}",
                                                  chatId: "$cid${widget.otherUserId}",
                                                  recipientPhoto: otheruser.photoUrl!,
                                                  pinned: false,
                                                  recipientPhoneNo: otheruser.phoneNo,
                                                  backgroundImage: "assets/backgroundimage.png",
                                                  lastMessageTime: DateTime.now()
                                                ));
                                            encrypt.Key symmKey = encrypt.Key
                                                .fromSecureRandom(32);
                                            String symmKeyString = symmKey.base64;
                                            RSAPublicKey publicKey = rsa.RsaKeyHelper()
                                                .parsePublicKeyFromPem(
                                                otheruser.publicKey);
                                            encrypt.Encrypter encrypter = encrypt
                                                .Encrypter(
                                                encrypt.RSA(publicKey: publicKey));
                                            encrypt
                                                .Encrypted encryptedSymmKey = encrypter
                                                .encrypt(symmKeyString);
                                            String encrytedSymmKeyString = encryptedSymmKey
                                                .base64;
                                            final Users currentuser =
                                            (await RemoteServices().getSingleUser(
                                                cid))!;
                                            otherUserChat=UserChat(
                                              id: "${widget.otherUserId}$cid",
                                              chatId: "$cid${widget.otherUserId}",
                                              recipientPhoto: currentuser.photoUrl!,
                                              pinned: false,
                                              recipientPhoneNo: currentuser.phoneNo,
                                              backgroundImage: "assets/backgroundimage.png",
                                              containsSymmKey: encrytedSymmKeyString,
                                              lastMessageTime:DateTime.now(),
                                            );
                                            await RemoteServices().setUserChat(
                                                otheruser.id,
                                                otherUserChat!
                                            );
                                            await const FlutterSecureStorage().write(
                                                key: "$cid${widget.otherUserId}",
                                                value: symmKeyString);
                                            setState(() {
                                              chatid = "$cid${widget.otherUserId}";
                                            });
                                          }
                                        }
                                        String symmKeyString = (await FlutterSecureStorage()
                                            .read(key: chatid!))!;
                                        encrypt.Key symmKey = encrypt.Key.fromBase64(
                                            symmKeyString);
                                        encrypt.Encrypter encrypter = encrypt.Encrypter(
                                            encrypt.AES(symmKey, padding: null));
                                        encrypt.Encrypted encryptedMessage = encrypter
                                            .encrypt(temp, iv: iv);
                                        String encryptedMessageString = encryptedMessage
                                            .base64;

                                        if (otherUserStream!.token != null && !isEditing && otherUserStream!.current!=chatid && otherUserChat!.muted == false) {
                                          SendNotificationService().sendFCMChatMessage(
                                              otherUserStream!.token!,
                                              {'title': (otherUserChat!.displayName ?? curUser!.phoneNo), 'body': temp},
                                              {});
                                        }
                                        debugPrint("Chat window noti");
                                        if (!isEditing) {
                                          await ChatsRemoteServices().setChatMessage(
                                              chatid!,
                                              ChatMessage(
                                                  id: "${DateTime
                                                      .now()
                                                      .microsecondsSinceEpoch}",
                                                  senderId: cid,
                                                  text: encryptedMessageString,
                                                  contentType: "text",
                                                  timestamp: DateTime.now()));


                                          DocumentSnapshot docsnap = await FirebaseFirestore
                                              .instance
                                              .collection('users').doc(cid).collection(
                                              'userChats')
                                              .doc("$cid${widget.otherUserId}")
                                              .get();
                                          if (!docsnap.exists) {
                                            await RemoteServices().setUserChat(cid,
                                                UserChat(
                                                    id: "$cid${widget.otherUserId}",
                                                    chatId: chatid!,
                                                    recipientPhoto: otheruser.photoUrl!,
                                                    pinned: false,
                                                    recipientPhoneNo: otheruser.phoneNo,
                                                    backgroundImage: "assets/backgroundimage.png",
                                                    lastMessageTime: DateTime.now())
                                            );
                                          }
                                          debugPrint("Chat window Update user chats");

                                          RemoteServices().updateUserChat(
                                              cid,
                                              {
                                                'lastMessage': encryptedMessageString,
                                                'lastMessageType': "text",
                                                'lastMessageTime': DateTime.now()
                                                    .toIso8601String(),
                                                'isSender':true
                                              },
                                              "$cid${widget.otherUserId}");

                                          docsnap =
                                          await FirebaseFirestore.instance.collection(
                                              'users').doc(widget.otherUserId)
                                              .collection(
                                              'userChats')
                                              .doc("${widget.otherUserId}$cid")
                                              .get();
                                          if (!docsnap.exists) {
                                            final Users currentuser = (await RemoteServices()
                                                .getSingleUser(cid))!;
                                            otherUserChat=UserChat(
                                              id: "${widget.otherUserId}$cid",
                                              chatId: "$cid${widget.otherUserId}",
                                              recipientPhoto: currentuser.photoUrl!,
                                              pinned: false,
                                              recipientPhoneNo: currentuser.phoneNo,
                                              backgroundImage: "assets/backgroundimage.png",
                                              //containsSymmKey: encrytedSymmKeyString,
                                              lastMessageTime:DateTime.now(),
                                            );
                                            await RemoteServices().setUserChat(
                                                otheruser.id,
                                                otherUserChat!
                                            );
                                            otherUserChat=UserChat(
                                                    id: "${widget.otherUserId}$cid",
                                                    chatId: chatid!,
                                                    recipientPhoto: currentuser
                                                        .photoUrl!,
                                                    pinned: false,
                                                    recipientPhoneNo: currentuser
                                                        .phoneNo,
                                                    backgroundImage: "assets/backgroundimage.png",
                                                    lastMessageTime: DateTime.now());
                                          }


                                          RemoteServices().updateUserChat(
                                              widget.otherUserId,
                                              {
                                                'lastMessage': encryptedMessageString,
                                                'lastMessageType': "text",
                                                'lastMessageTime': DateTime.now()
                                                    .toIso8601String(),
                                                'isSender':false
                                              },
                                              "${widget.otherUserId}$cid");
                                        }
                                        if (isEditing) {
                                          ChatsRemoteServices().updateChatMessage(
                                              chatid!,
                                              {'text': encryptedMessageString,
                                                'edited': true}, editingId);
                                          setState(() {
                                            isEditing = false;
                                          });
                                        }
                                        debugPrint("Chat window set state false");
                                        setState(() {
                                          isSending = false;
                                        });
                                      }
                                    },
                                    icon: const Icon(Icons.send_rounded, color: Colors.blue),
                                  ),
                                ],
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
        ));

  }

}

