import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'package:thumbnailer/thumbnailer.dart';

import '../Models/chatMessages.dart';
import '../Models/chats.dart';
import '../Models/userChats.dart';
import '../Models/users.dart';
import '../Services/chats_remote_services.dart';
import '../Services/users_remote_services.dart';

class PreviewPage extends StatefulWidget {
  final FilePickerResult result;
  final String? chatid;
  final Users otheruser;
  const PreviewPage( {Key? key,required this.result, required this.chatid, required this.otheruser}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  String? chatid;
  bool done = false;
  @override
  void initState() {
    chatid=widget.chatid;
    // TODO: implement initState
    super.initState();
  }
  bool isuploading=false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
                child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
                   const Expanded(child: BackButton()),
                    Flexible(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.result.paths.length,
                        itemBuilder: (context,index){
                       return Thumbnail(
                         dataResolver: () async {
                           return (await DefaultAssetBundle.of(context)
                               .load(
                               widget.result.paths[index]!))
                               .buffer
                               .asUint8List();
                         },
                         mimeType:
                         widget.result.files[index].extension!,
                         widgetSize: 500,
                         decoration: WidgetDecoration(
                             wrapperBgColor: Colors.grey
                         ),
                       );
                       },

            ),
                    ),
                  Container(
                  decoration: const BoxDecoration(
                  shape: BoxShape.circle
              ),
                    child: IconButton(onPressed: () async {
                    if (chatid == null) {
                      await ChatsRemoteServices().setChat(Chat(
                        id: "$cid${widget.otheruser.id}",
                        participantIds: [cid, widget.otheruser.id],
                      ));
                    }
                      await RemoteServices().setUserChat(
                      cid,
                      UserChat(
                        id: "$cid${widget.otheruser.id}",
                        chatId: "$cid${widget.otheruser.id}",
                        recipientPhoto: widget.otheruser.photoUrl!,
                        pinned: false,
                        recipientPhoneNo: widget.otheruser.phoneNo,
                        backgroundImage: "https://wallup.net/wp-content/uploads/2018/03/19/580162-pattern-vertical-portrait_display-digital_art.jpg",
                      ));
                      final Users currentuser =
                      (await RemoteServices().getSingleUser(cid))!;
                      await RemoteServices().setUserChat(
                        widget.otheruser.id,
                        UserChat(
                        id: "${widget.otheruser.id}$cid",
                        chatId: "$cid${widget.otheruser.id}",
                        recipientPhoto: currentuser.photoUrl!,
                        pinned: false,
                        recipientPhoneNo: currentuser.phoneNo,
                        backgroundImage: "https://wallup.net/wp-content/uploads/2018/03/19/580162-pattern-vertical-portrait_display-digital_art.jpg",
                      ));
                      setState(() {
                    chatid = "$cid${widget.otheruser.id}";
                    });





                //     if(!done){
                //  final docsnap = await FirebaseFirestore.instance.collection('users').doc(widget.otheruser.id).collection('userChats').doc("${widget.otheruser.id}$cid").get();
                //   if(!docsnap.exists){
                //     final Users currentuser = (await RemoteServices().getSingleUser(cid))!;
                //     await RemoteServices().setUserChat(widget.otheruser.id,
                //         UserChat(id: "${widget.otheruser.id}$cid", chatId: chatid!, recipientPhoto: currentuser.photoUrl!, pinned: false, recipientPhoneNo: currentuser.phoneNo)
                //     );
                //   }
                // }





                  for (int i = 0; i < widget.result.files.length; i++) {
                    // firebase_storage.Reference ref =
                    // firebase_storage.FirebaseStorage.instance.ref(
                    //     '/documents/${DateTime.fromMicrosecondsSinceEpoch}');
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
                            contentType: "document ${widget.result.files[i].name}",
                            timestamp: DateTime.now(),
                            senderUrl: widget.result.paths[i]!));

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
                      'lastMessage': (widget.result.files[widget.result.files.length-1].name.length >
                          100
                          ?widget.result.files[widget.result.files.length-1].name.substring(0, 100)
                          : widget.result.files[widget.result.files.length-1]),
                      'lastMessageType': "document",
                      'lastMessageTime': DateTime.now().toIso8601String()
                    },
                    "$cid${widget.otheruser.id}");


                Navigator.pop(context,true);

              }, icon: const Icon(Icons.send_rounded)),
            )

          ],
        ),
      ),
     );
  }
}
