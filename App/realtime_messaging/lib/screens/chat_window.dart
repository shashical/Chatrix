import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/chatMessages.dart';
import 'package:realtime_messaging/Models/chats.dart';
import 'package:realtime_messaging/Models/users.dart';
import 'package:realtime_messaging/Services/users_remote_services.dart';
import 'package:realtime_messaging/screens/user_info.dart';

import '../Services/chats_remote_services.dart';

class MyBubble extends StatelessWidget {
  MyBubble(
      {required this.message, required this.time, required this.delivered,required this.isUser,required this.read});

  final String message, time;
  final bool isUser,delivered,read;

  @override
  Widget build(BuildContext context) {
    final bg = !isUser ? Colors.white : Colors.greenAccent.shade100;
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
                      "12:00",
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.done_all,
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
  final String backgroundImage,otherUserId;
  final String? chatId;

  const ChatWindow({
    required this.otherUserId,
    this.backgroundImage = "https://wallup.net/wp-content/uploads/2018/03/19/580162-pattern-vertical-portrait_display-digital_art.jpg",
    this.chatId,
    Key? key,
  }) : super(key: key);

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  List<String> messages = [
    "Hello!",
    "Hi! How are you?",
    "I'm good. Thanks!",
    "That's great! I hope we can meet up soon and catch up on everything.",
  ];

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late Users otheruser;
  bool isTheOtherUserLoaded = false;

  void getTheOtherUser(String id)async{
    otheruser = (await RemoteServices().getSingleUser(id))!;
    setState(() {
      isTheOtherUserLoaded = true;
    });
  }

  @override
  void initState() {
    getTheOtherUser(widget.otherUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (isTheOtherUserLoaded==false?CircularProgressIndicator():Scaffold(
      appBar: AppBar(
        elevation: .9,
        title: Text('Friend'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
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
            StreamBuilder<List<ChatMessage>>(
              stream: (widget.chatId==null?null:ChatsRemoteServices().getChatMessages(widget.chatId!)),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  final List<ChatMessage> chatmessages = snapshot.data!;
                  return ListView.builder(
                    itemCount: chatmessages.length,
                    itemBuilder: (context, index) {
                      final ChatMessage chatmessage = chatmessages[index];
                      if(chatmessage.deletedForMe[cid]==null){
                        return MyBubble(message: chatmessage.text, time: ("${chatmessage.timestamp.hour}${chatmessage.timestamp.minute}"), delivered: chatmessage.delivered, isUser: (chatmessage.senderId==cid), read: chatmessage.read);
                      }
                      else{
                        return SizedBox(height: 0,);
                      }
                    },
                  );
                }
                else{
                  return Text("Say hi to ${otheruser.phoneNo}!");
                }
              },
            ),
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.95),
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
                        onPressed: () async{
                          if(widget.chatId==null){
                            await ChatsRemoteServices().setChat(
                              Chat(
                                id: "$cid${widget.otherUserId}",
                                participantIds: [cid,widget.otherUserId],
                              )
                            );
                          }
                          final String chatid = (widget.chatId==null?"$cid${widget.otherUserId}":widget.chatId)!;
                          messageController.clear();
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent+50,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                        icon: Icon(Icons.send_rounded, color: Colors.blue),
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

