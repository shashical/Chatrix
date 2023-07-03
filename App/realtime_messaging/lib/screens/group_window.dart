import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_messaging/Models/users.dart';
import 'package:realtime_messaging/Services/groups_remote_services.dart';
import 'package:realtime_messaging/Services/users_remote_services.dart';
import 'package:realtime_messaging/main.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'dart:math'as math;
import '../Models/groupMessages.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart' as rsa;
import '../constants.dart';

class MyBubble extends StatelessWidget {
  MyBubble({
    required this.message,
    required this.time,
    required this.delivered,
    required this.isUser,
    required this.read,
    required this.isAcontact,
    required this.displayName,
    required this.phoneNo, required this.isSelected,
  });

  final String message, time;
  final bool isUser, delivered, read,isSelected;
  final String? displayName, phoneNo;
  final bool? isAcontact;


  @override
  Widget build(BuildContext context) {
    final bg =isSelected?Colors.lightBlue.withOpacity(.5):
        !isUser ? Colors.white : const Color.fromARGB(255, 126, 226, 155);
    final align = !isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
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
        Container(
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
            color: bg,
            borderRadius: radius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              (isUser
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(((isAcontact!) ? '' : '~') + (displayName!)),
                        Text(((isAcontact!) ? '' : (phoneNo!))),
                      ],
                    )),
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
                    (!isUser
                        ? const SizedBox()
                        : Icon(
                            icon,
                            size: 16,
                          ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class GroupWindow extends StatefulWidget {
  final String backgroundImage, groupPhoto, groupName;
  final String groupId;

  const GroupWindow({
    required this.groupName,
    required this.groupPhoto,
    required this.backgroundImage,
    required this.groupId,
    Key? key,
  }) : super(key: key);

  @override
  State<GroupWindow> createState() => _GroupWindowState();
}

class _GroupWindowState extends State<GroupWindow> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isSending=false;
  List<bool> isSelected=[];
  List<int> otherUserChatSelected=[];
  int myMessageLength=0;
  int trueCount=0;
  File? _image;
  String? backgroundImage;
  List<GroupMessage> groupmessages=[];
  @override
  void initState() {
    // TODO: implement initState
    backgroundImage=widget.backgroundImage;
    super.initState();
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
      appBar: AppBar(

        elevation: .9,
        title:(trueCount!=0)?Row(
          children: [
            IconButton(onPressed: (){
              setState(() {

                isSelected=List.filled(groupmessages.length, false);
                trueCount=0;
                otherUserChatSelected=[];
              });
            }, icon: const Icon(Icons.arrow_back)),
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
                      for(int i=groupmessages.length-1;i>=0;i--){
                        if(isSelected[i]){
                          GroupsRemoteServices().deleteSingleGroupMessage(widget.groupId, groupmessages[i].id);
                        }

                      }
                      setState(() {
                        isSelected=List.filled(myMessageLength, false);
                        trueCount=0;
                      });

                    },
                        child: const Text('Delete for Everyone',style: TextStyle(color: Colors.green),)),
                  ):const SizedBox(width: 0,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(onPressed: () async {
                      for(int i=0;i<groupmessages.length;i++){
                        if(isSelected[i]) {
                          groupmessages[i].deletedForMe[cid] = true;

                          GroupsRemoteServices().updateGroupMessage(
                              widget.groupId,
                              {'deletedForMe': groupmessages[i].deletedForMe},
                              groupmessages[i].id);
                        }
                      }

                      setState(() {
                        isSelected=List.filled(myMessageLength, false);
                        trueCount=0;
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
            IconButton(onPressed: (){

            }, icon: const Icon(Icons.star)),
            const SizedBox(width: 18,),
            (trueCount==1 &&groupmessages[isSelected.indexOf(true)].contentType=='text' )?IconButton(onPressed: () async {
              await Clipboard.setData(ClipboardData(text: groupmessages[isSelected.indexOf(true)].text));
            }, icon: const Icon(Icons.copy)):const SizedBox(width: 0,),

          ],
        ) : Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.groupPhoto),
            ),
            const SizedBox(width: 10,),
            Text(widget.groupName),
            Spacer(),
            PopupMenuButton(itemBuilder: (context)=>
            [
              PopupMenuItem(
                child:const Text('Clear chat'),
                onTap: (){
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    for(int i=0;i<groupmessages.length;i++){
                      if(isSelected[i]) {
                        groupmessages[i].deletedForMe[cid] = true;

                        GroupsRemoteServices().updateGroupMessage(
                            widget.groupId,
                            {'deletedForMe': groupmessages[i].deletedForMe},
                            groupmessages[i].id);
                      }
                    }

                  });
                },),

              PopupMenuItem(child: const Text('Change Wallpaper'),
                onTap: (){
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    showDialog(context: (context), builder: (context)=>
                        AlertDialog(
                          title: const Text('Pick Image from'),
                          actions: [
                            ElevatedButton(onPressed: () async {
                              final image = await ImagePicker().pickImage(source: ImageSource.camera);
                              if (image == null) {
                                return;
                              }
                              final imageTemp = File(image.path);
                                backgroundImage=imageTemp.path;
                              RemoteServices().updateUserGroup(cid, {'backgroundImage':imageTemp.path}, widget.groupId);

                              setState(() {

                              });
                              Navigator.of(context, rootNavigator: true).pop();
                            }, child: const Text('Camera')),
                            ElevatedButton(onPressed: () async {
                              final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if (image == null) {
                                return;
                              }
                              final imageTemp = File(image.path);
                              backgroundImage=imageTemp.path;
                              RemoteServices().updateUserGroup(cid, {'backgroundImage':imageTemp.path}, widget.groupId);

                              setState(() {

                              });
                              Navigator.of(context, rootNavigator: true).pop();
                            }, child: const Text('Gallery'),)
                          ],
                        )
                    );


                  });
                },
              )
            ])
          ],
        ),
        //actions:  <Widget>[],
      ),
      body: Container(
        decoration: BoxDecoration(
          image:!(backgroundImage=='assets/backgroundimage.png')? DecorationImage(
          image:FileImage(File(backgroundImage!)),
          fit: BoxFit.cover,
        ):DecorationImage(image: AssetImage(backgroundImage!),)
        ),
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder<List<GroupMessage>>(
                stream: GroupsRemoteServices().getGroupMessages(widget.groupId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {                
                    groupmessages = snapshot.data!;
                    if(myMessageLength!=groupmessages.length){
                      myMessageLength=groupmessages.length;
                      isSelected=List.filled(myMessageLength, false);
                      trueCount=0;

                    }
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

                    Widget listBuilder = ListView.builder(
                      controller: scrollController,
                      itemCount: groupmessages.length,
                      itemBuilder: (context, index) {
                        final GroupMessage groupmessage = groupmessages[index];
                        if (groupmessage.deletedForMe[cid] == null &&
                            groupmessage.deletedForEveryone == false) {
                            
                            String? symmKeyString;
                            return FutureBuilder(
                              future: const FlutterSecureStorage().read(key: widget.groupId),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){

                                  symmKeyString = snapshot.data;
                                  encrypt.Key symmKey = encrypt.Key.fromBase64(symmKeyString!);
                                  encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(symmKey));
                                  encrypt.Encrypted encryptedMessage = encrypt.Encrypted.fromBase64(groupmessage.text);
                                  String message = encrypter.decrypt(encryptedMessage,iv: iv);

                                  return GestureDetector(
                            child: MyBubble(
                              message: message,
                              time:
                                  ("${groupmessage.timestamp.hour}:${groupmessage.timestamp.minute}"),
                              delivered: false,
                              isUser: (groupmessage.senderId == cid),
                              read: false,
                              displayName: (!savedNumber.contains(groupmessage.senderPhoneNo)?groupmessage.senderName:savedUsers[savedNumber.indexOf(groupmessage.senderPhoneNo)]),
                              isAcontact: false,
                              phoneNo: groupmessage.senderPhoneNo, isSelected: isSelected[index],
                            ),
                            onTap: () {

                              if (trueCount != 0) {
                                setState(() {


                                  if (isSelected[index]) {
                                    isSelected[index] = false;
                                    trueCount--;
                                    if(groupmessage.senderId!=cid){
                                      otherUserChatSelected.remove(index);
                                    }
                                  }
                                  else {
                                    trueCount++;
                                    isSelected[index] = true;
                                    if(groupmessage.senderId!=cid){
                                      otherUserChatSelected.add(index);
                                    }
                                  } });
                              }
                            },
                            onLongPress: (){
                              setState(() {
                                if(isSelected[index]){
                                  isSelected[index]=false;
                                  trueCount--;
                                  if(groupmessage.senderId!=cid){
                                    otherUserChatSelected.remove(index);
                                  }
                                }
                                else{
                                  trueCount++;
                                  isSelected[index]=true;
                                  if(groupmessage.senderId!=cid){
                                    otherUserChatSelected.add(index);
                                  }
                                }
                              });
                            },
                          );
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
                            );

                          
                        } else {
                          return const SizedBox(
                            height: 0,
                          );
                        }
                      },
                    );

                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent + 50,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });

                    return listBuilder;

                  } else {
                    return const Center(child: Text("No conversations yet."));
                  }
                },
              ),
            ),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.95),
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        style: const TextStyle(fontSize: 19),
                        maxLines: null,
                        controller: messageController,
                        onChanged: (e){
                          if(messageController.text.isEmpty||messageController.text.length==1){
                            setState(() {
                               // debugPrint('${messageController.text.length}');
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "Type here...",
                          border: InputBorder.none,
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
                              final files=await GroupsRemoteServices().pickDocument();
                              if(files!=null) {
                                final Users currentuser =
                                (await RemoteServices().getSingleUser(cid))!;
                                for (int i = 0; i < files.files.length; i++) {
                                  await GroupsRemoteServices().setGroupMessage(
                                      widget.groupId,
                                      GroupMessage(
                                        id: "${DateTime
                                            .now()
                                            .microsecondsSinceEpoch}",
                                        senderId: cid,
                                        text: '',
                                        contentType: "document ${files.files[i]
                                            .name}",
                                        timestamp: DateTime.now(),
                                        senderName: currentuser.name!,
                                        senderPhoneNo: currentuser.phoneNo,
                                        senderPhotoUrl: currentuser.photoUrl!,
                                        senderUrl: files.files[i].path!
                                      ));
                                }

                                DocumentSnapshot docSnap = await RemoteServices()
                                    .reference.collection('groups').doc(
                                    widget.groupId)
                                    .get();
                                List<dynamic> participants = docSnap.get(
                                    'participantIds');
                                // .getDocumentField(
                                //     "groups/${widget.groupId}", 'participantIds');
                                for (var x in participants) {
                                  RemoteServices().updateUserGroup(
                                      x,
                                      {
                                        'lastMessage': (files.files[files.files
                                            .length - 1].name.length >
                                            100
                                            ? files.files[files.files.length -
                                            1].name.substring(0, 100)
                                            : files.files[files.files.length -
                                            1].name),
                                        'lastMessageType': "document",
                                        'lastMessageTime': DateTime.now()
                                            .toIso8601String()
                                      },
                                      widget.groupId);
                                }
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
                                final Users currentuser =
                                (await RemoteServices().getSingleUser(cid))!;
                                for (int i = 0; i < 1; i++) {
                                  await GroupsRemoteServices().setGroupMessage(
                                      widget.groupId,
                                      GroupMessage(
                                          id: "${DateTime
                                              .now()
                                              .microsecondsSinceEpoch}",
                                          senderId: cid,
                                          text: '',
                                          contentType: "image",
                                          timestamp: DateTime.now(),
                                          senderName: currentuser.name!,
                                          senderPhoneNo: currentuser.phoneNo,
                                          senderPhotoUrl: currentuser.photoUrl!,
                                          senderUrl: _image!.path
                                      ));
                                }

                                DocumentSnapshot docSnap = await RemoteServices()
                                    .reference.collection('groups').doc(
                                    widget.groupId)
                                    .get();
                                List<dynamic> participants = docSnap.get(
                                    'participantIds');
                                // .getDocumentField(
                                //     "groups/${widget.groupId}", 'participantIds');
                                for (var x in participants) {
                                  RemoteServices().updateUserGroup(
                                      x,
                                      {
                                        'lastMessage':'image',
                                        'lastMessageType': "image",
                                        'lastMessageTime': DateTime.now()
                                            .toIso8601String()
                                      },
                                      widget.groupId);
                                }

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

                                final Users currentuser =
                                (await RemoteServices().getSingleUser(cid))!;
                                for (int i = 0; i < 1; i++) {
                                  await GroupsRemoteServices().setGroupMessage(
                                      widget.groupId,
                                      GroupMessage(
                                          id: "${DateTime
                                              .now()
                                              .microsecondsSinceEpoch}",
                                          senderId: cid,
                                          text: '',
                                          contentType: "image",
                                          timestamp: DateTime.now(),
                                          senderName: currentuser.name!,
                                          senderPhoneNo: currentuser.phoneNo,
                                          senderPhotoUrl: currentuser.photoUrl!,
                                          senderUrl: _image!.path
                                      ));
                                }

                                DocumentSnapshot docSnap = await RemoteServices()
                                    .reference.collection('groups').doc(
                                    widget.groupId)
                                    .get();
                                List<dynamic> participants = docSnap.get(
                                    'participantIds');
                                // .getDocumentField(
                                //     "groups/${widget.groupId}", 'participantIds');
                                for (var x in participants) {
                                  RemoteServices().updateUserGroup(
                                      x,
                                      {
                                        'lastMessage':'image',
                                        'lastMessageType': "image",
                                        'lastMessageTime': DateTime.now()
                                            .toIso8601String()
                                      },
                                      widget.groupId);
                                }
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
                  ((messageController.text.isEmpty || isSending)?const SizedBox(width: 0,):IconButton(
                    iconSize: 24,
                    onPressed: () async {
                      setState(() {
                        isSending=true;
                      });
                      String temp = messageController.text;
                      messageController.clear();
                      final Users currentuser =
                          (await RemoteServices().getSingleUser(cid))!;
                      
                      String symmKeyString = (await FlutterSecureStorage().read(key: widget.groupId))!;
                      encrypt.Key symmKey = encrypt.Key.fromBase64(symmKeyString);
                      encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(symmKey));
                      encrypt.Encrypted encryptedMessage = encrypter.encrypt(temp,iv: iv);
                      String encryptedMessageString = encryptedMessage.base64;

                      await GroupsRemoteServices().setGroupMessage(
                          widget.groupId,
                          GroupMessage(
                            id: "${DateTime.now().microsecondsSinceEpoch}",
                            senderId: cid,
                            text: encryptedMessageString,
                            contentType: "text",
                            timestamp: DateTime.now(),
                            senderName: currentuser.name!,
                            senderPhoneNo: currentuser.phoneNo,
                            senderPhotoUrl: currentuser.photoUrl!,
                          ));
                      DocumentSnapshot docSnap = await RemoteServices().reference.collection('groups').doc('${widget.groupId}').get();
                      List<dynamic> participants = docSnap.get('participantIds');
                          // .getDocumentField(
                          //     "groups/${widget.groupId}", 'participantIds');
                      for (var x in participants) {
                        RemoteServices().updateUserGroup(
                            x,
                            {
                              'lastMessage': encryptedMessageString,
                              'lastMessageType': "text",
                              'lastMessageTime': DateTime.now().toIso8601String()
                            },
                            widget.groupId);
                      }
                      setState(() {
                        debugPrint('$isSending');
                        isSending = false;
                      });
                    },
                    icon: const Icon(Icons.send_rounded, color: Colors.blue),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
