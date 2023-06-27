import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/chatMessages.dart';
import 'package:realtime_messaging/Models/chats.dart';
import 'package:realtime_messaging/Models/userChats.dart';
import 'package:realtime_messaging/Models/users.dart';
import 'package:realtime_messaging/Services/groups_remote_services.dart';
import 'package:realtime_messaging/Services/users_remote_services.dart';
import 'package:realtime_messaging/screens/user_info.dart';

import '../Models/groupMessages.dart';
import '../Services/chats_remote_services.dart';

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
              Text(message, style: TextStyle(fontSize: 17)),
              SizedBox(
                height: 1,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 55.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    (!isUser
                        ? SizedBox()
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.groupPhoto),
        ),
        elevation: .9,
        title: Text(widget.groupName),
        actions: <Widget>[],
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
            StreamBuilder<List<GroupMessage>>(
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
                  return ListView.builder(
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
                          displayName: groupmessage.senderName,
                          isAcontact: false,
                          phoneNo: groupmessage.senderPhoneNo,
                        );
                      } else {
                        return SizedBox(
                          height: 0,
                        );
                      }
                    },
                  );
                } else {
                  return Text("No conversations yet.");
                }
              },
            ),
            Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.95),
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                        style: TextStyle(fontSize: 19),
                        maxLines: null,
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "Type here...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () {},
                  ),
                  IconButton(
                    iconSize: (messageController.text == "" ? 0 : 24.0),
                    onPressed: () async {
                      final Users currentuser =
                          (await RemoteServices().getSingleUser(cid))!;
                      await GroupsRemoteServices().setGroupMessage(
                          widget.groupId,
                          GroupMessage(
                            id: "${DateTime.now().microsecondsSinceEpoch}",
                            senderId: cid,
                            text: messageController.text,
                            contentType: "text",
                            timestamp: DateTime.now(),
                            senderName: currentuser.name!,
                            senderPhoneNo: currentuser.phoneNo,
                            senderPhotoUrl: currentuser.photoUrl!,
                          ));
                      messageController.clear();
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent + 50,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      final List<String> participants = await RemoteServices()
                          .getDocumentField(
                              "groups/${widget.groupId}", 'participantIds');
                      for (var x in participants) {
                        RemoteServices().updateUserGroup(
                            x,
                            {
                              'lastMessage': (messageController.text.length >
                                      100
                                  ? "${messageController.text.substring(0, 100)}"
                                  : messageController.text),
                              'lastMessageType': "text",
                              'lastMessageTime': DateTime.now()
                            },
                            widget.groupId);
                      }
                    },
                    icon: Icon(Icons.send_rounded, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
