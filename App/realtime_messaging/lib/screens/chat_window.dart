import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/chatMessages.dart';
import 'package:realtime_messaging/Models/chats.dart';
import 'package:realtime_messaging/Models/userChats.dart';
import 'package:realtime_messaging/Models/users.dart';
import 'package:realtime_messaging/Services/users_remote_services.dart';
import 'package:realtime_messaging/main.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'dart:math'as math;
import '../Services/chats_remote_services.dart';

class MyBubble extends StatelessWidget {
  const MyBubble(
      {super.key, required this.message,
      required this.time,
      required this.delivered,
      required this.isUser,
      required this.read});

  final String message, time;
  final bool isUser, delivered, read;

  @override
  Widget build(BuildContext context) {
    final bg = !isUser ? Colors.white : Colors.greenAccent.shade100;
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
              Text(message, style: TextStyle(fontSize: 17)),
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
                    Icon(
                      icon,
                      size: 16,
                    )
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

class ChatWindow extends StatefulWidget {
  final String backgroundImage, otherUserId;
  final String? chatId;

  const ChatWindow({
    required this.otherUserId,
    this.backgroundImage =
        "https://wallup.net/wp-content/uploads/2018/03/19/580162-pattern-vertical-portrait_display-digital_art.jpg",
    this.chatId,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late Users otheruser;
  bool isTheOtherUserLoaded = false;
  String? chatid;
  int indexInContact=-1;
  bool isSending=false;
  bool blocked=false;
  bool done = false;

  void getTheOtherUser(String id) async {
    otheruser = (await RemoteServices().getSingleUser(id))!;
    setState(() {
      isTheOtherUserLoaded = true;
      indexInContact=savedNumber.indexOf(otheruser.phoneNo);
    });
  }

  @override
  void initState() {
    chatid = widget.chatId;
    getTheOtherUser(widget.otherUserId);

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return (isTheOtherUserLoaded == false
        ? const CircularProgressIndicator()
        : Scaffold(
            appBar: AppBar(
              elevation: .9,

              title: Row(
                children: [
                  CircleAvatar(
                    foregroundImage: NetworkImage(otheruser.photoUrl!),
                  ),
                  const SizedBox(width: 10,),
                  Text((indexInContact!=-1)?savedUsers[indexInContact]:otheruser.phoneNo),
                ],
              ),
              // actions: <Widget>[
              //
              // ],
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
                    child: StreamBuilder<List<ChatMessage>>(
                      stream: (chatid == null
                          ? null
                          : ChatsRemoteServices().getChatMessages(chatid!)),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {

                          final List<ChatMessage> chatmessages = snapshot.data!;
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

                            Widget listBuilder=ListView.builder(
                            controller: scrollController,
                            itemCount: chatmessages.length,
                            itemBuilder: (context, index) {
                              final ChatMessage chatmessage = chatmessages[index];
                              if (chatmessage.deletedForMe[cid] == null && chatmessage.deletedForEveryone == false) {
                                return MyBubble(
                                    message: chatmessage.text,
                                    time:
                                        ("${chatmessage.timestamp.hour}:${chatmessage.timestamp.minute~/10}${chatmessage.timestamp.minute%10}"),
                                    delivered: chatmessage.delivered,
                                    isUser: (chatmessage.senderId == cid),
                                    read: chatmessage.read);
                              } else {
                                return const SizedBox(
                                  height: 0,
                                );
                              }
                            },
                          );
                         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                             scrollController.animateTo(
                             scrollController.position.maxScrollExtent + 60,
                             duration: const Duration(milliseconds: 300),
                             curve: Curves.easeOut,
                           );
                         }) ;

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
                                if(messageController.text.length ==1 || messageController.text.isEmpty){
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
                        (messageController.text.isEmpty || isSending)?const SizedBox(width: 0,):IconButton(
                          iconSize: (24.0),
                          onPressed: () async {
                            setState(() {
                              isSending=true;
                            });
                            String temp = messageController.text;
                            messageController.clear();
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
                                      backgroundImage: "https://wallup.net/wp-content/uploads/2018/03/19/580162-pattern-vertical-portrait_display-digital_art.jpg",
                                      ));
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
                                      backgroundImage: "https://wallup.net/wp-content/uploads/2018/03/19/580162-pattern-vertical-portrait_display-digital_art.jpg"
                                      ));
                              setState(() {
                                chatid = "$cid${widget.otherUserId}";
                              });
                            }
                            await ChatsRemoteServices().setChatMessage(
                                chatid!,
                                ChatMessage(
                                    id: "${DateTime.now().microsecondsSinceEpoch}",
                                    senderId: cid,
                                    text: temp,
                                    contentType: "text",
                                    timestamp: DateTime.now()));
                            
                            DocumentSnapshot docsnap = await FirebaseFirestore.instance
                            .collection('users').doc(cid).collection('userChats').doc("$cid${widget.otherUserId}").get();
                            if(!docsnap.exists){
                              await RemoteServices().setUserChat(cid,
                              UserChat(id: "$cid${widget.otherUserId}", chatId: chatid!, recipientPhoto: otheruser.photoUrl!, pinned: false, recipientPhoneNo: otheruser.phoneNo)
                              );
                              setState(() {
                                done = true;
                              });
                            }

                            RemoteServices().updateUserChat(
                                cid,
                                {
                                  'lastMessage': (temp
                                              .length >
                                          100
                                      ? temp.substring(0, 100)
                                      : temp),
                                  'lastMessageType': "text",
                                  'lastMessageTime': DateTime.now().toIso8601String()
                                },
                                "$cid${widget.otherUserId}");

                            if(!done){
                              docsnap = await FirebaseFirestore.instance.collection('users').doc(widget.otherUserId).collection('userChats').doc("${widget.otherUserId}$cid").get();
                              if(!docsnap.exists){
                                final Users currentuser = (await RemoteServices().getSingleUser(cid))!;
                                await RemoteServices().setUserChat(widget.otherUserId,
                                UserChat(id: "${widget.otherUserId}$cid", chatId: chatid!, recipientPhoto: currentuser.photoUrl!, pinned: false, recipientPhoneNo: currentuser.phoneNo)
                                );
                              }
                            }

                            RemoteServices().updateUserChat(
                                widget.otherUserId,
                                {
                                  'lastMessage': (temp
                                              .length >
                                          100
                                      ? temp.substring(0, 100)
                                      : temp),
                                  'lastMessageType': "text",
                                  'lastMessageTime': DateTime.now().toIso8601String()
                                },
                                "${widget.otherUserId}$cid");
                            setState(() {
                              isSending=false;
                            });
                          },
                          icon: const Icon(Icons.send_rounded, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
  }
}

// import 'package:flutter/material.dart';
// import 'package:realtime_messaging/Models/chats.dart';

// class MyBubble extends StatelessWidget {
//   MyBubble(
//       {required this.message, required this.time, required this.delivered,required this.isUser,required this.read});

//   final String message, time;
//   final bool isUser,delivered,read;

//   @override
//   Widget build(BuildContext context) {
//     final bg = !isUser ? Colors.white : Colors.greenAccent.shade100;
//     final align = !isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end;
//     final icon = delivered ? Icons.done_all : Icons.done;
//     final radius = !isUser
//         ? BorderRadius.only(
//             topRight: Radius.circular(5.0),
//             bottomLeft: Radius.circular(10.0),
//             bottomRight: Radius.circular(5.0),
//           )
//         : BorderRadius.only(
//             topLeft: Radius.circular(5.0),
//             bottomLeft: Radius.circular(5.0),
//             bottomRight: Radius.circular(10.0),
//           );
//     return Column(
//       crossAxisAlignment: align,
//       children: [
//         Container(
//           constraints:
//               BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
//           margin: const EdgeInsets.all(3.0),
//           padding: const EdgeInsets.all(8.0),
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                   blurRadius: .5,
//                   spreadRadius: 1.0,
//                   color: Colors.black.withOpacity(.12))
//             ],
//             color: bg,
//             borderRadius: radius,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(message, style: TextStyle(fontSize: 17)),
//               SizedBox(
//                 height: 1,
//               ),
//               ConstrainedBox(
//                 constraints: BoxConstraints(maxWidth: 55.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       "12:00",
//                       style: TextStyle(fontSize: 13),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     Icon(
//                       Icons.done_all,
//                       size: 16,
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ChatWindow extends StatefulWidget {
//   final String backgroundImage;
//   final String? chatId;

//   const ChatWindow({
//     this.backgroundImage = "https://wallup.net/wp-content/uploads/2018/03/19/580162-pattern-vertical-portrait_display-digital_art.jpg",
//     this.chatId,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<ChatWindow> createState() => _ChatWindowState();
// }

// class _ChatWindowState extends State<ChatWindow> {
//   List<String> messages = [
//     "Hello!",
//     "Hi! How are you?",
//     "I'm good. Thanks!",
//     "That's great! I hope we can meet up soon and catch up on everything.",
//   ];

//   TextEditingController messageController = TextEditingController();
//   ScrollController scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: .9,
//         title: Text('Friend'),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.more_vert),
//             onPressed: () {},
//           )
//         ],
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: NetworkImage(widget.backgroundImage),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 controller: scrollController,
//                 padding: EdgeInsets.all(16.0),
//                 itemCount: messages.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return MyBubble(
//                     message: messages[index],
//                     time: "12:00",
//                     delivered: true,
//                     isUser: index % 2 == 0,
//                   );
//                 },
//               ),
//             ),
//                 Container(
//                   constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.95),
//                   margin: EdgeInsets.all(8.0),
//                   padding: EdgeInsets.symmetric(horizontal: 8.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(24.0),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 16.0),
//                           child: TextField(
//                             style: TextStyle(fontSize: 19),
//                             maxLines: null,
//                             controller: messageController,
//                             decoration: InputDecoration(
//                               hintText: "Type here...",
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.attach_file),
//                         onPressed: () {},
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             messages.add(messageController.text);
//                           });
//                           messageController.clear();
//                           scrollController.animateTo(
//                             scrollController.position.maxScrollExtent+50,
//                             duration: Duration(milliseconds: 300),
//                             curve: Curves.easeOut,
//                           );
//                         },
//                         icon: Icon(Icons.send_rounded, color: Colors.blue),
//                       ),
//                     ],
//                   ),
//                 ),
//           ],
//         ),
//       ),
//     );
//   }
// }

