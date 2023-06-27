import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/userChats.dart';
import 'package:realtime_messaging/main.dart';
import 'package:realtime_messaging/screens/chat_window.dart';
import 'package:realtime_messaging/screens/search_contacts.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import '../Services/users_remote_services.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final RemoteServices _usersremoteServices = RemoteServices();
  int index=-1;
  List<bool> isSelected=[];

  @override
  Widget build(BuildContext context) {
    debugPrint('printingcid $cid');
    return Scaffold(
      body: StreamBuilder<List<UserChat>>(
        stream: _usersremoteServices.getUserChats(cid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<UserChat> userchats = snapshot.data!;

            if (userchats.isEmpty) {
              return const Center(
                child: Text('No chats to display.'),
              );
            }

            isSelected = List.filled(userchats.length, false);

            // userchats.sort((a, b) {
            //   if (a.pinned != b.pinned) {
            //     return a.pinned ? -1 : 1;
            //   }
            //   if (a.pinned) {
            //     return b.lastMessageTime!.compareTo(a.lastMessageTime!);
            //   }
            //   return b.lastMessageTime!.compareTo(a.lastMessageTime!);
            // });
            int trueCount=0;
            List<int> unMutedSelected=[];
            List<int> unPinnedSelected=[];

            return ListView.builder(
              itemCount: userchats.length,
              itemBuilder: (context, index) {
                final UserChat userchat = userchats[index];
                if (userchat.deleted) {
                  return const SizedBox();
                }
                else {
                  final ind = savedNumber.indexOf(userchat.recipientPhoneNo);
                  return Column(
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
                                      _usersremoteServices.updateUserGroup(
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
                                });
                              }
                              else{
                                for (int i = 0; i < userchats.length; i++) {
                                  if (!userchats[i].muted && isSelected[i]) {
                                    try {
                                      _usersremoteServices.updateUserGroup(
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
                                });

                              }

                            },
                            icon:(unMutedSelected.isEmpty)? const Icon(Icons.volume_up_rounded):const Icon(Icons.volume_mute_rounded),
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
                                        _usersremoteServices.updateUserGroup(
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
                                  });
                                }
                                else{
                                  for (int i = 0; i < userchats.length; i++) {
                                    if (!userchats[i].pinned && isSelected[i]) {
                                      try {
                                        _usersremoteServices.updateUserGroup(
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
                                  });

                                }
                              },
                              icon:(unPinnedSelected.isEmpty)? const Icon((CupertinoIcons.pin_slash_fill)):const Icon(CupertinoIcons.pin_fill)),
                          const SizedBox(
                            width:20,
                          ),
                          IconButton(onPressed: (){
                            for(int i=0;i<userchats.length;i++) {
                              if (isSelected[i]) {
                                try {
                                  _usersremoteServices.updateUserGroup(
                                      cid, {'deleted': true}, userchats[i].id)
                                      .catchError((e) => throw Exception('$e'));
                                  userchats[i].deleted = true;
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
                              }
                            }
                            setState(() {isSelected=List.filled(userchats.length,false);
                              trueCount=0;
                            });


                          }, icon: const Icon(Icons.delete)),
                          PopupMenuButton(
                              itemBuilder: (context)=>[
                                PopupMenuItem(
                                  child: const Text('Select All'),
                                  onTap: (){
                                    setState(() {

                                    });
                                  },
                                )
                              ])
                        ],
                      ):const SizedBox(width: 0,),
                      ListTile(
                        leading: Stack(
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
                        title: Text((ind != -1) ? savedUsers[ind] : userchat
                            .recipientPhoneNo),
                        subtitle: Text(userchat.lastMessage ?? "",maxLines: 1, overflow: TextOverflow.ellipsis,),
                        trailing: Text((userchat.lastMessageTime == null
                            ? ""
                            : "${userchat.lastMessageTime!.hour}:${userchat
                            .lastMessageTime!.minute ~/ 10}${userchat
                            .lastMessageTime!.minute % 10}")),
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
                      ),
                    ],
                  );
                }
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
