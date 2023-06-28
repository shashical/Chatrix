import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/userChats.dart';
import 'package:realtime_messaging/Services/chats_remote_services.dart';
import 'package:realtime_messaging/main.dart';
import 'package:realtime_messaging/screens/chat_window.dart';
import 'package:realtime_messaging/screens/otherUser_profile_page.dart';
import 'package:realtime_messaging/screens/search_contacts.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import '../Services/users_remote_services.dart';
import 'dart:math' as math;

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final RemoteServices _usersremoteServices = RemoteServices();
  int index=-1;
  List<bool> isSelected=[];
  int trueCount=0;
  List<UserChat> userchats=[];
  List<int> unMutedSelected=[];
  List<int> unPinnedSelected=[];
  bool isIntialised=false;
  int mychatlength=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          (trueCount!=0)?Row(
            children: [
              const SizedBox(width: 20,),
              Text('Selected: $trueCount'),
              const Spacer(),
              IconButton(
                onPressed: (){
                  if(unMutedSelected.isEmpty) {
                    for (int i = 0; i < userchats.length; i++) {
                      if (userchats[i].muted && isSelected[i]) {
                        try {
                          _usersremoteServices.updateUserChat(
                              cid, {'muted': false}, userchats[i].id)
                              .catchError((e) =>
                          throw Exception('$e'));

                          userchats[i].muted = false;

                        } on FirebaseException catch (e) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                content:
                                Text('${e.message}')));
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                content: Text('$e')));
                        }
                      }

                    }

                    setState(() {
                      isSelected=List.filled(userchats.length,false);
                      trueCount=0;
                      unMutedSelected=[];
                      unPinnedSelected=[];
                    });
                  }
                  else{
                    for (int i = 0; i < userchats.length; i++) {
                      if (!userchats[i].muted && isSelected[i]) {
                        try {
                          _usersremoteServices.updateUserChat(
                              cid, {'muted': true}, userchats[i].id)
                              .catchError((e) =>
                          throw Exception('$e'));

                          userchats[i].muted = true;

                        } on FirebaseException catch (e) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                content:
                                Text('${e.message}')));
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(SnackBar(
                                content: Text('$e')));
                        }
                      }

                    }
                    setState(() {
                      isSelected=List.filled(userchats.length, false);
                      trueCount=0;
                      unMutedSelected=[];
                      unPinnedSelected=[];
                    });

                  }

                },
                icon:(unMutedSelected.isEmpty)? const Icon(Icons.volume_up_rounded,semanticLabel: 'Unmute',):const Icon(CupertinoIcons.volume_off,semanticLabel: 'mute',),
              ),
              const SizedBox(
                width:20,
              ),
              IconButton(
                  onPressed: (){
                    if(unPinnedSelected.isEmpty) {
                      for (int i = 0; i < userchats.length; i++) {
                        if (userchats[i].pinned && isSelected[i]) {
                          try {
                            _usersremoteServices.updateUserChat(
                                cid, {'pinned': false}, userchats[i].id)
                                .catchError((e) =>
                            throw Exception('$e'));

                            userchats[i].pinned = false;

                          } on FirebaseException catch (e) {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  content:
                                  Text('${e.message}')));
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  content: Text('$e')));
                          }
                        }

                      }

                      setState(() {
                        isSelected=List.filled(userchats.length,false);
                        trueCount=0;
                        unMutedSelected=[];
                        unPinnedSelected=[];
                      });
                    }
                    else{
                      for (int i = 0; i < userchats.length; i++) {
                        if (!userchats[i].pinned && isSelected[i]) {
                          try {
                            _usersremoteServices.updateUserChat(
                                cid, {'pinned': true}, userchats[i].id)
                                .catchError((e) =>
                            throw Exception('$e'));

                            userchats[i].pinned = true;

                          } on FirebaseException catch (e) {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  content:
                                  Text('${e.message}')));
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(SnackBar(
                                  content: Text('$e')));
                          }
                        }

                      }
                      setState(() {
                        isSelected=List.filled(userchats.length, false);
                        trueCount=0;
                        unPinnedSelected=[];
                        unMutedSelected=[];
                      });

                    }
                  },
                  icon:(unPinnedSelected.isEmpty)? Transform.rotate(angle: math.pi/7,
                  child: const Icon((CupertinoIcons.pin_slash_fill),semanticLabel: 'unpin',)):Transform.rotate(angle: math.pi/7,
                  child: const Icon(CupertinoIcons.pin_fill,semanticLabel: 'pin',))),
              const SizedBox(
                width:20,
              ),
              IconButton(onPressed: ()async{
                for(int i=userchats.length-1;i>=0;i--) {
                  String temp = userchats[i].id;
                  String chatid = userchats[i].chatId;
                  if (isSelected[i]) {
                    try {
                      RemoteServices().deleteSingleUserChat(cid, userchats[i].id)
                      // _usersremoteServices.updateUserChat(
                      //     cid, {'deleted': true}, userchats[i].id)
                          .catchError((e) => throw Exception('$e'));
                    } on FirebaseException catch (e) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(
                                content:
                                Text('${e.message}')));
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                            SnackBar(
                                content:
                                Text('$e')));
                    }
                    String otheruserid = temp.substring(cid.length, temp.length);
                    DocumentSnapshot docsnap = await FirebaseFirestore.instance.collection('users').doc(otheruserid).collection('userChats').doc("$otheruserid$cid").get();
                    if(!docsnap.exists){
                      await ChatsRemoteServices().deleteAllChatMessages(chatid);
                    }
                    else{
                      await ChatsRemoteServices().deleteAllChatMessagesForMe(cid, chatid);
                    }
                  }
                }
                setState(() {
                  isSelected=List.filled(userchats.length,false);
                trueCount=0;
                unPinnedSelected=[];
                unMutedSelected=[];
                });


              }, icon: const Icon(Icons.delete,semanticLabel: 'delete',)),
              PopupMenuButton(
                  itemBuilder: (context)=>[
                    PopupMenuItem(
                      child:  Text((trueCount==userchats.length)?'Unselect All':'Select All'),
                      onTap: (){
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {
                          if(trueCount!=userchats.length) {
                            isSelected = List.filled(userchats.length, true);
                            trueCount = userchats.length;
                          }
                          else{
                            isSelected=List.filled(userchats.length, false);
                            trueCount=0;
                          }
                        });
                        });
                      },
                    )
                  ])
            ],
          ):const SizedBox(width: 0,),

          Flexible(
            child: StreamBuilder<List<UserChat>>(
              stream: _usersremoteServices.getUserChats(cid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  userchats = snapshot.data!;
                  if(mychatlength!=userchats.length){
                    isSelected=List.filled(userchats.length,false);
                    mychatlength=userchats.length;
                  }


                  if (userchats.isEmpty) {
                    return const Center(
                      child: Text('No chats to display.'),
                    );
                  }



                  userchats.sort((a, b) {
                    if (a.pinned != b.pinned) {
                      return a.pinned ? -1 : 1;
                    }
                    if (a.pinned) {
                      return b.lastMessageTime!.compareTo(a.lastMessageTime!);
                    }
                    return b.lastMessageTime!.compareTo(a.lastMessageTime!);
                  });


                  return ListView.builder(
                    itemCount: userchats.length,
                    itemBuilder: (context, index) {
                      final UserChat userchat = userchats[index];
                        final ind = savedNumber.indexOf(userchat.recipientPhoneNo);
                        return ListTile(
                          leading: InkWell(
                            child: Stack(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        userchat.recipientPhoto),
                                  ),
                                  (isSelected[index]) ?
                                  const Positioned(
                                      bottom: 1,
                                      right: 5,
                                      child: Icon(Icons.check_circle, size: 16,
                                        color: Colors.cyan,)) :
                                  const SizedBox(height: 0, width: 0,)
                                ]
                            ),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>OtherUserProfilePage(chatId: userchat.chatId,)));
                            },
                          ),
                          title: Text((ind != -1) ? savedUsers[ind] : userchat
                              .recipientPhoneNo),
                          subtitle: Text(userchat.lastMessage ?? "",maxLines: 1, overflow: TextOverflow.ellipsis,),
                          trailing: SizedBox(
                            height: 50,
                            width: 80,
                            child: Column(
                              children: [
                                Text((userchat.lastMessageTime == null
                                    ? ""
                                    : "${userchat.lastMessageTime!.hour}:${userchat.lastMessageTime!.minute~/10}${userchat.lastMessageTime!.minute%10}")),
                                Row(
                                  children: [
                                    userchat.pinned? Transform.rotate(angle: math.pi/7,
                                        child: const Icon(CupertinoIcons.pin_fill,size: 20,)):const SizedBox(width: 0,),
                                    userchat.muted? const Icon(CupertinoIcons.volume_off,size:20) :const SizedBox(width: 0,),
                                  ],
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            if(trueCount!=0) {
                              if (isSelected[index]) {
                                setState(() {
                                  if(!userchats[index].muted){
                                    unMutedSelected.remove(index);

                                  }
                                  if(!userchats[index].pinned){
                                    unPinnedSelected.remove(index);
                                  }
                                  isSelected[index] = false;
                                  trueCount--;
                                });
                              }
                              else{
                                setState(() {
                                  if(!userchats[index].muted){
                                    unMutedSelected.add(index);
                                  }
                                  if(!userchats[index].pinned){
                                    unPinnedSelected.add(index);
                                  }

                                  isSelected[index]=true;
                                  trueCount++;
                                });
                              }

                            }
                            else{
                              final otheruserid = userchat.id.substring(cid.length,userchat.id.length);
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return ChatWindow(otherUserId: otheruserid, chatId: userchat.chatId, backgroundImage: userchat.backgroundImage!,);
                              },));
                            }
                          },
                          onLongPress: () {

                            if(isSelected[index]){
                              setState(() {
                                if(!userchats[index].muted){
                                  unMutedSelected.remove(index);

                                }
                                if(!userchats[index].pinned){
                                  unPinnedSelected.remove(index);
                                }
                                isSelected[index]=false;
                                trueCount--;
                              });

                            }
                            else{
                              setState(() {
                                if(!userchats[index].muted){
                                  unMutedSelected.add(index);

                                }
                                if(!userchats[index].pinned){
                                  unPinnedSelected.add(index);
                                }
                                isSelected[index]=true;
                                trueCount++;
                              });

                            }

                          },
                        );
                    },
                  );
                }
                else if(snapshot.connectionState==ConnectionState.waiting){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else if(snapshot.hasError){
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                else{
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan.shade800,
        child: const Icon(Icons.search),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const SearchContactPage(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40),
              ),
            ),
            clipBehavior: Clip.antiAlias,
          );
        },
      ),
    );
  }
}
