import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:realtime_messaging/Models/userChats.dart';
import 'package:realtime_messaging/Services/chats_remote_services.dart';
import 'package:realtime_messaging/constants.dart';
import 'package:realtime_messaging/main.dart';
import 'package:realtime_messaging/screens/chat_window.dart';
import 'package:realtime_messaging/screens/home_page.dart';
import 'package:realtime_messaging/screens/otherUser_profile_page.dart';
import 'package:realtime_messaging/screens/search_contacts.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import '../Models/users.dart';
import '../Services/users_remote_services.dart';
import 'dart:math' as math;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart' as rsa;

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
    return WillPopScope(
      onWillPop: () async {
        if(trueCount!=0){
          setState(() {
            trueCount=0;

            isSelected=List.filled(userchats.length, false);
           unPinnedSelected=[];
           unMutedSelected=[];

          });
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
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
                    debugPrint('My chats first stream');
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
                        final otheruserid = userchat.id.substring(cid.length,userchat.id.length);
                        if(userchat.displayName=='' || userchat.displayName==null ){
                          RemoteServices().updateUserChat(cid,{'displayName':(ind!=-1)?savedUsers[ind]:userchat.recipientPhoneNo}, userchat.id);
                        }
                        else if(ind!=-1 && userchat.displayName!=savedUsers[ind] ){
                          RemoteServices().updateUserChat(cid, {'displayName':savedUsers[ind]}, userchat.id);
                        }

                          if(userchat.containsSymmKey != null){
                            String encryptedSymmKeyString = userchat.containsSymmKey!;
                            encrypt.Encrypted encryptedSymmKey = encrypt.Encrypted.fromBase64(encryptedSymmKeyString);
                            String? privateKeyString;
                            return FutureBuilder(
                              future:  const FlutterSecureStorage().read(key: cid),

                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  privateKeyString = snapshot.data;
                                  RSAPrivateKey privateKey = rsa.RsaKeyHelper().parsePrivateKeyFromPem(privateKeyString);
                                  encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.RSA(privateKey: privateKey));
                                  String symmKeyString = encrypter.decrypt(encryptedSymmKey);
                                  return Column(
                                    children: [

                                      FutureBuilder(
                                        future:  const FlutterSecureStorage().write(key: userchat.chatId, value: symmKeyString),
                                        builder: (context, snapshot) {
                                          debugPrint("My chats containssymmkey");
                                          return FutureBuilder(
                                            future: RemoteServices().updateUserChat(cid,
                                                {
                                                  'containsSymmKey': null,
                                                }
                                                , userchat.id),
                                            builder: (context, snapshot) {
                                              String? symmKeyString;
                                              return FutureBuilder(
                                                future: const FlutterSecureStorage().read(key: userchat.chatId),
                                                builder: (context, snapshot) {
                                                  if(snapshot.hasData){

                                                    String message=userchat.lastMessage!;
                                                    if(userchat.lastMessageType=='text'){
                                                    symmKeyString = snapshot.data;
                                                    encrypt.Key symmKey = encrypt.Key.fromBase64(symmKeyString!);
                                                    encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(symmKey,padding: null));

                                                    encrypt.Encrypted encryptedMessage = encrypt.Encrypted.fromBase64(userchat.lastMessage!);
                                                    message = encrypter.decrypt(encryptedMessage,iv: iv);}
                                                    if(userchat.isSender) {
                                                      return StreamBuilder<UserChat>(
                                                      stream: RemoteServices().getUserChatStream(otheruserid, '$otheruserid$cid'),
                                                      builder: (context, snapshot) {
                                                        debugPrint("getuserchatstream my chats");
                                                        final UserChat? otherUserChat=snapshot.data;
                                                        final count=otherUserChat!.unreadMessageCount??0;
                                                        debugPrint('my chat is culprit because of this stream builder ');
                                                        return ListTile(
                                                          tileColor: isSelected[index]?Colors.blue.withOpacity(0.5):null,
                                                          leading: InkWell(
                                                            child: Stack(
                                                                children: [
                                                                  CircleAvatar(
                                                                    backgroundImage: NetworkImage(
                                                                        !(curUser!.blockedBy?.contains(otheruserid)??false)? userchat.recipientPhoto:'http://ronaldmottram.co.nz/wp-content/uploads/2019/01/default-user-icon-8.jpg'),
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
                                                          subtitle:IntrinsicWidth(
                                                            child: Row(
                                                              children: [
                                                                ConstrainedBox(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.57,),
                                                                    child: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                                                const SizedBox(width: 5,),
                                                                (count==0)?const Icon(Icons.done_all, size: 20,):const Icon(Icons.done,size: 20,)
                                                              ],
                                                            ),
                                                          ),
                                                          trailing: IntrinsicWidth(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text((userchat.lastMessageTime == null
                                                                    ? ""
                                                                    : "${userchat.lastMessageTime!.hour}:${userchat.lastMessageTime!.minute~/10}${userchat.lastMessageTime!.minute%10}")),
                                                                Container(
                                                                  constraints: BoxConstraints(
                                                                      maxHeight:(userchat.unreadMessageCount!=0 || userchat.pinned||userchat.muted)?50:0 ),
                                                                  child: Row(
                                                                    children: [
                                                                      userchat.pinned? Transform.rotate(angle: math.pi/7,
                                                                          child: const Icon(CupertinoIcons.pin_fill,size: 20,)):const SizedBox(width: 0,height: 0,),
                                                                      userchat.muted? const Icon(CupertinoIcons.volume_off,size:20) :const SizedBox(width: 0,height: 0,),
                                                                      userchat.unreadMessageCount!=0? Container(
                                                                        padding: const EdgeInsets.all(3),
                                                                        decoration:
                                                                      const BoxDecoration(shape: BoxShape.circle,color: Colors.orangeAccent),
                                                                        child:Text('${userchat.unreadMessageCount}',
                                                                          style: const TextStyle(color: Colors.white70),) ,):
                                                                      const SizedBox(width: 0,height: 0,)
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () async {
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
                                                              RemoteServices().updateUser(cid,
                                                                  {'current':userchat.id});
                                                            final result=await  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                                return ChatWindow(otherUserId: otheruserid, chatId: userchat.chatId, backgroundImage: userchat.backgroundImage!,);
                                                              },));
                                                              debugPrint("my chats current update");
                                                            RemoteServices().updateUser(cid,{'current':result});
                                                            current=null;
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
                                                      }
                                                    );
                                                    }
                                                    else{
                                                      debugPrint("my chats else list tile");
                                                      return ListTile(
                                                        tileColor: isSelected[index]?Colors.blue.withOpacity(0.5):null,
                                                        leading: InkWell(
                                                          child: Stack(
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundImage: NetworkImage(
                                                                      !(curUser!.blockedBy?.contains(otheruserid)??false)? userchat.recipientPhoto:'http://ronaldmottram.co.nz/wp-content/uploads/2019/01/default-user-icon-8.jpg'),
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
                                                        subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                        trailing: SizedBox(
                                                          height: 50,
                                                          width: 80,
                                                          child: Column(
                                                            children: [
                                                              Text((userchat.lastMessageTime == null
                                                                  ? ""
                                                                  : "${userchat.lastMessageTime!.hour}:${userchat.lastMessageTime!.minute~/10}${userchat.lastMessageTime!.minute%10}")),
                                                              Container(
                                                                constraints: BoxConstraints(
                                                                    maxHeight:(userchat.unreadMessageCount!=0 || userchat.pinned||userchat.muted)?50:0 ),
                                                                child: Row(
                                                                  children: [
                                                                    userchat.pinned? Transform.rotate(angle: math.pi/7,
                                                                        child: const Icon(CupertinoIcons.pin_fill,size: 20,)):const SizedBox(width: 0,height: 0,),
                                                                    userchat.muted? const Icon(CupertinoIcons.volume_off,size:20) :const SizedBox(width: 0,height: 0,),
                                                                    userchat.unreadMessageCount!=0? Container(
                                                                      padding: const EdgeInsets.all(3),
                                                                      decoration:
                                                                      const BoxDecoration(shape: BoxShape.circle,color: Colors.orangeAccent),
                                                                      child:Text('${userchat.unreadMessageCount}',
                                                                        style: const TextStyle(color: Colors.white70),) ,):
                                                                    const SizedBox(width: 0,height: 0,)
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        onTap: () async {
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
                                                            RemoteServices().updateUser(cid,
                                                                {'current':userchat.id});
                                                            debugPrint('my chat is culprit  ');
                                                            final result=await  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                              return ChatWindow(otherUserId: otheruserid, chatId: userchat.chatId, backgroundImage: userchat.backgroundImage!,);
                                                            },));
                                                            debugPrint("my chats current update");
                                                            RemoteServices().updateUser(cid,{'current':result});
                                                            current=null;
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
                                                    }
                                                  }
                                                  else if(snapshot.hasError){
                                                    throw Exception("symmKey not found or ${snapshot.error}");
                                                  }
                                                  else{
                                                    return const SizedBox(
                                                      height: 0,
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                }
                                else if(snapshot.hasError){
                                  throw Exception("Private key not found or ${snapshot.error}");
                                }
                                else{
                                  return const SizedBox(
                                    height: 0,
                                  );
                                }

                              },
                            );

                            // Builder(
                            //   builder: (context) {
                            //     return
                            //   },
                            // );
                            // Builder(
                            //   builder: (context) {
                            //     return
                            //   },
                            // );
                            //turned it back to null
                          }
                          else{
                            String? symmKeyString;
                            return FutureBuilder(
                              future: const FlutterSecureStorage().read(key: userchat.chatId),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                    String message=userchat.lastMessage!;
                                    if(userchat.lastMessageType=='text') {
                                      symmKeyString = snapshot.data;
                                      encrypt.Key symmKey = encrypt.Key
                                          .fromBase64(symmKeyString!);
                                      encrypt.Encrypter encrypter = encrypt
                                          .Encrypter(encrypt.AES(symmKey,padding: null));

                                      encrypt.Encrypted encryptedMessage = encrypt
                                          .Encrypted.fromBase64(
                                          userchat.lastMessage!);
                                      message = encrypter.decrypt(
                                          encryptedMessage, iv: iv);
                                    }
                                    if(userchat.isSender) {
                                      return StreamBuilder<UserChat>(
                                          stream: RemoteServices().getUserChatStream(otheruserid, '$otheruserid$cid'),
                                          builder: (context, snapshot) {
                                            debugPrint("getuserchatstream 2");
                                            final UserChat? otherUserChat=snapshot.data;
                                            final count=otherUserChat?.unreadMessageCount??0;
                                            return ListTile(
                                              tileColor: isSelected[index]?Colors.blue.withOpacity(0.5):null,
                                              leading: InkWell(
                                                child: Stack(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage: NetworkImage(
                                                            !(curUser?.blockedBy?.contains(otheruserid)??false)? userchat.recipientPhoto:'http://ronaldmottram.co.nz/wp-content/uploads/2019/01/default-user-icon-8.jpg'),
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
                                              subtitle: IntrinsicWidth(
                                                child: Row(
                                                  children: [
                                                    ConstrainedBox(constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.57,),
                                                    child: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                                    const SizedBox(width: 5,),
                                                    (count==0)?const Icon(Icons.done_all,size: 20,):const Icon(Icons.done,size: 20,)
                                                  ],
                                                ),
                                              ),
                                              trailing: IntrinsicWidth(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text((userchat.lastMessageTime == null
                                                        ? ""
                                                        : "${userchat.lastMessageTime!.hour}:${userchat.lastMessageTime!.minute~/10}${userchat.lastMessageTime!.minute%10}")),
                                                    Container(
                                                      constraints: BoxConstraints(
                                                          maxHeight:(userchat.unreadMessageCount!=0 || userchat.pinned||userchat.muted)?50:0 ),
                                                      child: Row(
                                                        children: [
                                                          userchat.pinned? Transform.rotate(angle: math.pi/7,
                                                              child: const Icon(CupertinoIcons.pin_fill,size: 20,)):const SizedBox(width: 0,height: 0,),
                                                          userchat.muted? const Icon(CupertinoIcons.volume_off,size:20) :const SizedBox(width: 0,height: 0,),
                                                          userchat.unreadMessageCount!=0? Container(
                                                            padding: const EdgeInsets.all(3),
                                                            decoration:
                                                            const BoxDecoration(shape: BoxShape.circle,color: Colors.orangeAccent),
                                                            child:Text('${userchat.unreadMessageCount}',
                                                              style: const TextStyle(color: Colors.white70),) ,):
                                                          const SizedBox(width: 0,height: 0,)
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onTap: () async {
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
                                                  RemoteServices().updateUser(cid,
                                                      {'current':userchat.id});
                                                  final result=await  Navigator.push(context, MaterialPageRoute(builder: (context) {
                                                    return ChatWindow(otherUserId: otheruserid, chatId: userchat.chatId, backgroundImage: userchat.backgroundImage!,);
                                                  },));
                                                  debugPrint("my chats current 3");
                                                  RemoteServices().updateUser(cid,{'current':result});
                                                  current=null;
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
                                          }
                                      );
                                    }
                                    else {
                                      debugPrint("list tile 4?");
                                      return ListTile(
                                    tileColor: isSelected[index]?Colors.blue.withOpacity(0.5):null,
                                    leading: InkWell(
                                      child: Stack(
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  !(curUser?.blockedBy?.contains(otheruserid)??false)? userchat.recipientPhoto:'http://ronaldmottram.co.nz/wp-content/uploads/2019/01/default-user-icon-8.jpg'),
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
                                    subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                    trailing: SizedBox(
                                      height: 50,
                                      width: 80,
                                      child: IntrinsicHeight(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text((userchat.lastMessageTime == null
                                                ? ""
                                                : "${userchat.lastMessageTime!.hour}:${userchat.lastMessageTime!.minute~/10}${userchat.lastMessageTime!.minute%10}")),
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxHeight:(userchat.unreadMessageCount!=0 || userchat.pinned||userchat.muted)?50:0 ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  userchat.pinned? Transform.rotate(angle: math.pi/7,
                                                      child: const Icon(CupertinoIcons.pin_fill,size: 20,)):const SizedBox(width: 0,height: 0,),
                                                  userchat.muted? const Icon(CupertinoIcons.volume_off,size:20) :const SizedBox(width: 0,height: 0,),
                                                  userchat.unreadMessageCount!=0? Container(
                                                    padding: const EdgeInsets.all(5),
                                                    decoration:
                                                  const BoxDecoration(shape: BoxShape.circle,color: Colors.orangeAccent),
                                                    child:Text('${userchat.unreadMessageCount}',
                                                      style: const TextStyle(color: Colors.white70),) ,):
                                                  const SizedBox(width: 0,height: 0,)
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
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
                                        RemoteServices().updateUser(cid, {'current':userchat.chatId});
                                        final result =await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                          return ChatWindow(otherUserId: otheruserid, chatId: userchat.chatId, backgroundImage: userchat.backgroundImage!,);
                                        },));
                                        RemoteServices().updateUser(cid, {'current':result});
                                        current=null;
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
                                    }
                                }
                                else if(snapshot.hasError){
                                  throw Exception("symmKey not found or ${snapshot.error}");
                                }
                                else{
                                  return const SizedBox(
                                    height: 0,
                                  );
                                }
                              },
                            );
                          }



                          // return

                          // return ListTile(
                          //   leading: InkWell(
                          //     child: Stack(
                          //         children: [
                          //           CircleAvatar(
                          //             backgroundImage: NetworkImage(
                          //                 userchat.recipientPhoto),
                          //           ),
                          //           (isSelected[index]) ?
                          //           const Positioned(
                          //               bottom: 1,
                          //               right: 5,
                          //               child: Icon(Icons.check_circle, size: 16,
                          //                 color: Colors.cyan,)) :
                          //           const SizedBox(height: 0, width: 0,)
                          //         ]
                          //     ),
                          //     onTap: (){
                          //       Navigator.push(context, MaterialPageRoute(builder: (context)=>OtherUserProfilePage(chatId: userchat.chatId,)));
                          //     },
                          //   ),
                          //   title: Text((ind != -1) ? savedUsers[ind] : userchat
                          //       .recipientPhoneNo),
                          //   subtitle: Text(userchat.lastMessage ?? "",maxLines: 1, overflow: TextOverflow.ellipsis,),
                          //   trailing: SizedBox(
                          //     height: 50,
                          //     width: 80,
                          //     child: Column(
                          //       children: [
                          //         Text((userchat.lastMessageTime == null
                          //             ? ""
                          //             : "${userchat.lastMessageTime!.hour}:${userchat.lastMessageTime!.minute~/10}${userchat.lastMessageTime!.minute%10}")),
                          //         Row(
                          //           children: [
                          //             userchat.pinned? Transform.rotate(angle: math.pi/7,
                          //                 child: const Icon(CupertinoIcons.pin_fill,size: 20,)):const SizedBox(width: 0,),
                          //             userchat.muted? const Icon(CupertinoIcons.volume_off,size:20) :const SizedBox(width: 0,),
                          //           ],
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          //   onTap: () {
                          //     if(trueCount!=0) {
                          //       if (isSelected[index]) {
                          //         setState(() {
                          //           if(!userchats[index].muted){
                          //             unMutedSelected.remove(index);

                          //           }
                          //           if(!userchats[index].pinned){
                          //             unPinnedSelected.remove(index);
                          //           }
                          //           isSelected[index] = false;
                          //           trueCount--;
                          //         });
                          //       }
                          //       else{
                          //         setState(() {
                          //           if(!userchats[index].muted){
                          //             unMutedSelected.add(index);
                          //           }
                          //           if(!userchats[index].pinned){
                          //             unPinnedSelected.add(index);
                          //           }

                          //           isSelected[index]=true;
                          //           trueCount++;
                          //         });
                          //       }

                          //     }
                          //     else{
                          //       final otheruserid = userchat.id.substring(cid.length,userchat.id.length);
                          //       Navigator.push(context, MaterialPageRoute(builder: (context) {
                          //         return ChatWindow(otherUserId: otheruserid, chatId: userchat.chatId, backgroundImage: userchat.backgroundImage!,);
                          //       },));
                          //     }
                          //   },
                          //   onLongPress: () {

                          //     if(isSelected[index]){
                          //       setState(() {
                          //         if(!userchats[index].muted){
                          //           unMutedSelected.remove(index);

                          //         }
                          //         if(!userchats[index].pinned){
                          //           unPinnedSelected.remove(index);
                          //         }
                          //         isSelected[index]=false;
                          //         trueCount--;
                          //       });

                          //     }
                          //     else{
                          //       setState(() {
                          //         if(!userchats[index].muted){
                          //           unMutedSelected.add(index);

                          //         }
                          //         if(!userchats[index].pinned){
                          //           unPinnedSelected.add(index);
                          //         }
                          //         isSelected[index]=true;
                          //         trueCount++;
                          //       });

                          //     }

                          //   },
                          // );
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
      ),
    );
  }
}
