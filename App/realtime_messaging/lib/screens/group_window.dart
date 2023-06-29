import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/users.dart';
import 'package:realtime_messaging/Services/groups_remote_services.dart';
import 'package:realtime_messaging/Services/users_remote_services.dart';
import 'package:realtime_messaging/main.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'dart:math'as math;
import '../Models/groupMessages.dart';

class MyBubble extends StatelessWidget {
  MyBubble({
    required this.message,
    required this.time,
    required this.delivered,
    required this.isUser,
    required this.read,
    required this.isAcontact,
    required this.displayName,
    required this.phoneNo,
  });

  final String message, time;
  final bool isUser, delivered, read;
  final String? displayName, phoneNo;
  final bool? isAcontact;

  @override
  Widget build(BuildContext context) {
    final bg =
        !isUser ? Colors.white : const Color.fromARGB(255, 126, 226, 155);
    final align = !isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = !isUser
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.groupPhoto),
        ),
        elevation: .9,
        title: Text(widget.groupName),
        actions:  <Widget>[],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Flexible(
              child: StreamBuilder<List<GroupMessage>>(
                stream: GroupsRemoteServices().getGroupMessages(widget.groupId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {                
                    final List<GroupMessage> groupmessages = snapshot.data!;
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
                          return MyBubble(
                            message: groupmessage.text,
                            time:
                                ("${groupmessage.timestamp.hour}:${groupmessage.timestamp.minute}"),
                            delivered: false,
                            isUser: (groupmessage.senderId == cid),
                            read: false,
                            displayName: (savedNumber.indexOf(groupmessage.senderPhoneNo)==-1?groupmessage.senderName:savedUsers[savedNumber.indexOf(groupmessage.senderPhoneNo)]),
                            isAcontact: false,
                            phoneNo: groupmessage.senderPhoneNo,
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
                    onPressed: () {},
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
                      await GroupsRemoteServices().setGroupMessage(
                          widget.groupId,
                          GroupMessage(
                            id: "${DateTime.now().microsecondsSinceEpoch}",
                            senderId: cid,
                            text: temp,
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
                              'lastMessage': (temp.length >
                                      100
                                  ? temp.substring(0, 100)
                                  : temp),
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
