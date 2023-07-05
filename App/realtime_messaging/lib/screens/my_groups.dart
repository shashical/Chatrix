import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/userGroups.dart';
import 'package:realtime_messaging/screens/group_info_page.dart';
import 'package:realtime_messaging/screens/group_window.dart';
import 'package:realtime_messaging/screens/search_group.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import '../Services/users_remote_services.dart';
import 'dart:math' as math;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart' as rsa;
import '../constants.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final RemoteServices _remoteServices = RemoteServices();
  List<bool> isSelected=[];
  List<UserGroup> usergroups=[];
  int trueCount=0;
  int myGroupsLength=0;
  List<int> unMutedSelected=[];
  List<int> unPinnedSelected=[];
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
                    for (int i = 0; i < usergroups.length; i++) {
                      if (usergroups[i].muted && isSelected[i]) {
                        try {
                          _remoteServices.updateUserGroup(
                              cid, {'muted': false}, usergroups[i].id)
                              .catchError((e) =>
                          throw Exception('$e'));

                          usergroups[i].muted = false;

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
                      isSelected=List.filled(usergroups.length,false);
                      trueCount=0;
                      unPinnedSelected=[];
                      unMutedSelected=[];
                    });
                  }
                  else{
                    for (int i = 0; i < usergroups.length; i++) {
                      if (!usergroups[i].muted && isSelected[i]) {
                        try {
                          _remoteServices.updateUserGroup(
                              cid, {'muted': true}, usergroups[i].id)
                              .catchError((e) =>
                          throw Exception('$e'));

                          usergroups[i].muted = true;

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
                      isSelected=List.filled(usergroups.length, false);
                      trueCount=0;
                      unMutedSelected=[];
                      unPinnedSelected=[];
                    });

                  }

                },
                icon:(unMutedSelected.isEmpty)? const Icon(Icons.volume_up_rounded,semanticLabel: 'unmute',):const Icon(Icons.volume_mute_rounded,semanticLabel: 'mute',),
              ),
              const SizedBox(
                width:20,
              ),
              IconButton(
                  onPressed: (){
                    if(unPinnedSelected.isEmpty) {
                      for (int i = 0; i < usergroups.length; i++) {
                        if (usergroups[i].pinned && isSelected[i]) {
                          try {
                            _remoteServices.updateUserGroup(
                                cid, {'pinned': false}, usergroups[i].id)
                                .catchError((e) =>
                            throw Exception('$e'));

                            usergroups[i].pinned = false;

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
                        isSelected=List.filled(usergroups.length,false);
                        trueCount=0;
                        unMutedSelected=[];
                        unPinnedSelected=[];
                      });
                    }
                    else{
                      for (int i = 0; i < usergroups.length; i++) {
                        if (!usergroups[i].pinned && isSelected[i]) {
                          try {
                            _remoteServices.updateUserGroup(
                                cid, {'pinned': true}, usergroups[i].id)
                                .catchError((e) =>
                            throw Exception('$e'));

                            usergroups[i].pinned = true;

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
                        isSelected=List.filled(usergroups.length, false);
                        trueCount=0;
                        unMutedSelected=[];
                        unPinnedSelected=[];
                      });

                    }
                  },
                  icon:(unPinnedSelected.isEmpty)? Transform.rotate(angle: math.pi/7,
                  child: const Icon((CupertinoIcons.pin_slash_fill),semanticLabel: 'Unpin',)):Transform.rotate(angle: math.pi/7,
                  child: const Icon(CupertinoIcons.pin_fill,semanticLabel: 'Pin',))),
              const SizedBox(
                width:20,
              ),
              PopupMenuButton(
                  itemBuilder: (context)=>[
                    PopupMenuItem(
                      child: const Text('Select All'),
                      onTap: (){
                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                          if(trueCount!=usergroups.length) {
                            setState(() {
                              isSelected = List.filled(usergroups.length, true);
                              trueCount = usergroups.length;
                            });
                          }
                          else{
                            setState(() {
                              isSelected=List.filled(usergroups.length, false);
                              trueCount=0;
                            });
                          }
                        });
                      },
                    ),
                    PopupMenuItem(child: Text('Exit group'),
                    onTap:(){
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        setState(() {

                        });
                      });
                    },),

                  ])
            ],
          ):const SizedBox(width: 0,),
          Flexible(
            child: StreamBuilder<List<UserGroup>>(
              stream: _remoteServices.getUserGroups(cid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                   usergroups = snapshot.data!;
                   if(myGroupsLength!=usergroups.length) {
                     isSelected = List.filled(usergroups.length, false);
                     myGroupsLength=usergroups.length;
                   }
                  if (usergroups.isEmpty) {
                    return const Center(
                      child: Text('No groups to display.'),
                    );
                  }

                  usergroups.sort((a, b) {
                    if(a.lastMessageTime == null || b.lastMessageTime == null){
                      return (a.lastMessageTime == null?-1:1);
                    }
                    if (a.pinned != b.pinned) {
                      return a.pinned ? -1 : 1;
                    }
                    if (a.pinned) {
                      return b.lastMessageTime!.compareTo(a.lastMessageTime!);
                    }
                    return b.lastMessageTime!.compareTo(a.lastMessageTime!);
                  });
                  return ListView.builder(
                    itemCount: usergroups.length,
                    itemBuilder: (context, index) {
                      final UserGroup usergroup = usergroups[index];

                      if(usergroup.containsSymmKey != null){
                        String encryptedSymmKeyString = usergroup.containsSymmKey!;
                        encrypt.Encrypted encryptedSymmKey = encrypt.Encrypted.fromBase64(encryptedSymmKeyString);
                        String? privateKeyString;
                        return FutureBuilder(
                          future: const FlutterSecureStorage().read(key: cid),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              privateKeyString = snapshot.data;
                              RSAPrivateKey privateKey = rsa.RsaKeyHelper().parsePrivateKeyFromPem(privateKeyString);
                              encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.RSA(privateKey: privateKey));
                              String symmKeyString = encrypter.decrypt(encryptedSymmKey);

                              return FutureBuilder(
                                future: const FlutterSecureStorage().write(key: usergroup.groupId, value: symmKeyString),
                                builder: (context, snapshot) {
                                  return FutureBuilder(
                                    future: RemoteServices().updateUserGroup(cid,
                                          {
                                            'containsSymmKey': null,
                                          }
                                          , usergroup.groupId),
                                    builder: (context, snapshot) {
                                      if(usergroup.lastMessageType == 'text' && usergroup.lastMessage != ''){
                                        String? symmKeyString;
                                        return FutureBuilder(
                                          future: const FlutterSecureStorage().read(key: usergroup.groupId),
                                          builder: (context, snapshot) {
                                            if(snapshot.hasData){
                                              symmKeyString = snapshot.data;
                                              encrypt.Key symmKey = encrypt.Key.fromBase64(symmKeyString!);
                                              encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(symmKey));

                                              encrypt.Encrypted encryptedMessage = encrypt.Encrypted.fromBase64(usergroup.lastMessage!);
                                              String message = encrypter.decrypt(encryptedMessage,iv: iv);
                                              return ListTile(
                        tileColor: isSelected[index]?Colors.blue.withOpacity(0.5):null,
                            leading: InkWell(
                              child: Stack(
                                children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(usergroup.imageUrl),
                                ),
                                  (isSelected[index])?
                                  const Positioned(
                                      bottom: 1,
                                      right: 5,
                                      child: Icon(Icons.check_circle,color: Colors.cyan,size: 16,))
                                      :const SizedBox(height: 0,width: 0,)
                              ]
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupInfoPage(groupId: usergroup.groupId,userGroupId: usergroup.id,)));
                              },
                            ),
                            title: Text(usergroup.name),
                            subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis,),
                            trailing: SizedBox(
                              width: 80,
                              height: 50,
                              child: Column(
                                children: [
                                  Text((usergroup.lastMessageTime == null
                                      ? ""
                                      : "${usergroup.lastMessageTime!.hour}:${usergroup.lastMessageTime!.minute~/10}${usergroup.lastMessageTime!.minute%10}")),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight:(usergroup.unreadMessageCount!=0 || usergroup.pinned||usergroup.muted)?50:0 ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        usergroup.pinned? Transform.rotate(angle: math.pi/7,
                                            child: const Icon(CupertinoIcons.pin_fill,size: 20,)):const SizedBox(width: 0,height: 0,),
                                        usergroup.muted? const Icon(CupertinoIcons.volume_off,size:20) :const SizedBox(width: 0,height: 0,),
                                        usergroup.unreadMessageCount!=0? Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration:
                                          const BoxDecoration(shape: BoxShape.circle,color: Colors.orangeAccent),
                                          child:Text('${usergroup.unreadMessageCount}',
                                            style: const TextStyle(color: Colors.white70),) ,):
                                        const SizedBox(width: 0,height: 0,)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              if (trueCount != 0) {
                                if (isSelected[index]) {
                                  setState(() {
                                    if (!usergroups[index].muted) {
                                      unMutedSelected.remove(index);
                                    }
                                    if (!usergroups[index].pinned) {
                                      unPinnedSelected.remove(index);
                                    }
                                    isSelected[index] = false;
                                    trueCount--;
                                  });
                                }
                                else {
                                  setState(() {
                                    if (!usergroups[index].muted) {
                                      unMutedSelected.add(index);
                                    }
                                    if (!usergroups[index].pinned) {
                                      unPinnedSelected.add(index);
                                    }

                                    isSelected[index] = true;
                                    trueCount++;
                                  });
                                }
                              }
                              else {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return GroupWindow(
                                          groupName: usergroup.name,
                                          groupPhoto: usergroup.imageUrl,
                                          backgroundImage: usergroup
                                              .backgroundImage,
                                          groupId: usergroup.groupId);
                                    },));
                              }
                            },
                            onLongPress: (){
                                  if(isSelected[index]) {
                                    setState(() {
                                      if (!usergroups[index].muted) {
                                        unMutedSelected.remove(index);
                                      }
                                      if (!usergroups[index].pinned) {
                                        unPinnedSelected.remove(index);
                                      }
                                      isSelected[index] = false;
                                      trueCount--;
                                    });
                                  }
                                  else{
                                    setState(() {
                                      if(!usergroups[index].muted){
                                        unMutedSelected.add(index);

                                      }
                                      if(!usergroups[index].pinned){
                                        unPinnedSelected.add(index);
                                      }
                                      isSelected[index]=true;
                                      trueCount++;
                                    });

                                  }
                            },
                          );
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
                                      else{
                                        return ListTile(
                        tileColor: isSelected[index]?Colors.blue.withOpacity(0.5):null,
                            leading: InkWell(
                              child: Stack(
                                children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(usergroup.imageUrl),
                                ),
                                  (isSelected[index])?
                                  const Positioned(
                                      bottom: 1,
                                      right: 5,
                                      child: Icon(Icons.check_circle,color: Colors.cyan,size: 16,))
                                      :const SizedBox(height: 0,width: 0,)
                              ]
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupInfoPage(groupId: usergroup.groupId,userGroupId: usergroup.id,)));
                              },
                            ),
                            title: Text(usergroup.name),
                            subtitle: Text(usergroup.lastMessage ?? "", maxLines: 1, overflow: TextOverflow.ellipsis,),
                            trailing: SizedBox(
                              width: 80,
                              height: 50,
                              child: Column(
                                children: [
                                  Text((usergroup.lastMessageTime == null
                                      ? ""
                                      : "${usergroup.lastMessageTime!.hour}:${usergroup.lastMessageTime!.minute~/10}${usergroup.lastMessageTime!.minute%10}")),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight:(usergroup.unreadMessageCount!=0 || usergroup.pinned||usergroup.muted)?50:0 ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        usergroup.pinned? Transform.rotate(angle: math.pi/7,
                                            child: const Icon(CupertinoIcons.pin_fill,size: 20,)):const SizedBox(width: 0,height: 0,),
                                        usergroup.muted? const Icon(CupertinoIcons.volume_off,size:20) :const SizedBox(width: 0,height: 0,),
                                        usergroup.unreadMessageCount!=0? Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration:
                                          const BoxDecoration(shape: BoxShape.circle,color: Colors.orangeAccent),
                                          child:Text('${usergroup.unreadMessageCount}',
                                            style: const TextStyle(color: Colors.white70),) ,):
                                        const SizedBox(width: 0,height: 0,)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {

                              if(trueCount!=0) {
                                if (isSelected[index]) {
                                  setState(() {
                                    if(!usergroups[index].muted){
                                      unMutedSelected.remove(index);

                                    }
                                    if(!usergroups[index].pinned){
                                      unPinnedSelected.remove(index);
                                    }
                                    isSelected[index] = false;
                                    trueCount--;
                                  });
                                }
                                else{
                                  setState(() {
                                    if(!usergroups[index].muted){
                                      unMutedSelected.add(index);
                                    }
                                    if(!usergroups[index].pinned){
                                      unPinnedSelected.add(index);
                                    }

                                    isSelected[index]=true;
                                    trueCount++;
                                  });
                                }

                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return GroupWindow(groupName: usergroup.name, groupPhoto: usergroup.imageUrl, backgroundImage: usergroup.backgroundImage, groupId: usergroup.groupId);
                                },));
                              }
                            },
                            onLongPress: (){
                                  if(isSelected[index]){
                                    setState(() {
                                      if(!usergroups[index].muted){
                                        unMutedSelected.remove(index);

                                      }
                                      if(!usergroups[index].pinned){
                                        unPinnedSelected.remove(index);
                                      }
                                      isSelected[index]=false;
                                      trueCount--;
                                    });

                                  }
                                  else{
                                    setState(() {
                                      if(!usergroups[index].muted){
                                        unMutedSelected.add(index);

                                      }
                                      if(!usergroups[index].pinned){
                                        unPinnedSelected.add(index);
                                      }
                                      isSelected[index]=true;
                                      trueCount++;
                                    });

                                  }
                            },
                          );
                                      }
                                    },
                                  );
                                },
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
                      }
                      else{
                        if(usergroup.lastMessageType == 'text' && usergroup.lastMessage != ''){
                                        String? symmKeyString;
                                        return FutureBuilder(
                                          future: const FlutterSecureStorage().read(key: usergroup.groupId),
                                          builder: (context, snapshot) {
                                            if(snapshot.hasData){
                                              symmKeyString = snapshot.data;
                                              encrypt.Key symmKey = encrypt.Key.fromBase64(symmKeyString!);
                                              encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(symmKey));

                                              encrypt.Encrypted encryptedMessage = encrypt.Encrypted.fromBase64(usergroup.lastMessage!);
                                              String message = encrypter.decrypt(encryptedMessage,iv: iv);
                                              return ListTile(
                        tileColor: isSelected[index]?Colors.blue.withOpacity(0.5):null,
                            leading: InkWell(
                              child: Stack(
                                children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(usergroup.imageUrl),
                                ),
                                  (isSelected[index])?
                                  const Positioned(
                                      bottom: 1,
                                      right: 5,
                                      child: Icon(Icons.check_circle,color: Colors.cyan,size: 16,))
                                      :const SizedBox(height: 0,width: 0,)
                              ]
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupInfoPage(groupId: usergroup.groupId,userGroupId: usergroup.id,)));
                              },
                            ),
                            title: Text(usergroup.name),
                            subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis,),
                            trailing: SizedBox(
                              width: 80,
                              height: 50,
                              child: Column(
                                children: [
                                  Text((usergroup.lastMessageTime == null
                                      ? ""
                                      : "${usergroup.lastMessageTime!.hour}:${usergroup.lastMessageTime!.minute~/10}${usergroup.lastMessageTime!.minute%10}")),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight:(usergroup.unreadMessageCount!=0 || usergroup.pinned||usergroup.muted)?50:0 ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        usergroup.pinned? Transform.rotate(angle: math.pi/7,
                                            child: const Icon(CupertinoIcons.pin_fill,size: 20,)):const SizedBox(width: 0,height: 0,),
                                        usergroup.muted? const Icon(CupertinoIcons.volume_off,size:20) :const SizedBox(width: 0,height: 0,),
                                        usergroup.unreadMessageCount!=0? Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration:
                                          const BoxDecoration(shape: BoxShape.circle,color: Colors.orangeAccent),
                                          child:Text('${usergroup.unreadMessageCount}',
                                            style: const TextStyle(color: Colors.white70),) ,):
                                        const SizedBox(width: 0,height: 0,)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {

                              if(trueCount!=0) {
                                if (isSelected[index]) {
                                  setState(() {
                                    if(!usergroups[index].muted){
                                      unMutedSelected.remove(index);

                                    }
                                    if(!usergroups[index].pinned){
                                      unPinnedSelected.remove(index);
                                    }
                                    isSelected[index] = false;
                                    trueCount--;
                                  });
                                }
                                else{
                                  setState(() {
                                    if(!usergroups[index].muted){
                                      unMutedSelected.add(index);
                                    }
                                    if(!usergroups[index].pinned){
                                      unPinnedSelected.add(index);
                                    }

                                    isSelected[index]=true;
                                    trueCount++;
                                  });
                                }

                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return GroupWindow(groupName: usergroup.name, groupPhoto: usergroup.imageUrl, backgroundImage: usergroup.backgroundImage, groupId: usergroup.groupId);
                                },));
                              }
                            },
                            onLongPress: (){
                                  if(isSelected[index]){
                                    setState(() {
                                      if(!usergroups[index].muted){
                                        unMutedSelected.remove(index);

                                      }
                                      if(!usergroups[index].pinned){
                                        unPinnedSelected.remove(index);
                                      }
                                      isSelected[index]=false;
                                      trueCount--;
                                    });

                                  }
                                  else{
                                    setState(() {
                                      if(!usergroups[index].muted){
                                        unMutedSelected.add(index);

                                      }
                                      if(!usergroups[index].pinned){
                                        unPinnedSelected.add(index);
                                      }
                                      isSelected[index]=true;
                                      trueCount++;
                                    });

                                  }
                            },
                          );
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
                                      else{
                                        return ListTile(
                        tileColor: isSelected[index]?Colors.blue.withOpacity(0.5):null,
                            leading: InkWell(
                              child: Stack(
                                children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(usergroup.imageUrl),
                                ),
                                  (isSelected[index])?
                                  const Positioned(
                                      bottom: 1,
                                      right: 5,
                                      child: Icon(Icons.check_circle,color: Colors.cyan,size: 16,))
                                      :const SizedBox(height: 0,width: 0,)
                              ]
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupInfoPage(groupId: usergroup.groupId,userGroupId: usergroup.id,)));
                              },
                            ),
                            title: Text(usergroup.name),
                            subtitle: Text(usergroup.lastMessage ?? "", maxLines: 1, overflow: TextOverflow.ellipsis,),
                            trailing: SizedBox(
                              width: 80,
                              height: 50,
                              child: Column(
                                children: [
                                  Text((usergroup.lastMessageTime == null
                                      ? ""
                                      : "${usergroup.lastMessageTime!.hour}:${usergroup.lastMessageTime!.minute~/10}${usergroup.lastMessageTime!.minute%10}")),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight:(usergroup.unreadMessageCount!=0 || usergroup.pinned||usergroup.muted)?50:0 ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        usergroup.pinned? Transform.rotate(angle: math.pi/7,
                                            child: const Icon(CupertinoIcons.pin_fill,size: 20,)):const SizedBox(width: 0,height: 0,),
                                        usergroup.muted? const Icon(CupertinoIcons.volume_off,size:20) :const SizedBox(width: 0,height: 0,),
                                        usergroup.unreadMessageCount!=0? Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration:
                                          const BoxDecoration(shape: BoxShape.circle,color: Colors.orangeAccent),
                                          child:Text('${usergroup.unreadMessageCount}',
                                            style: const TextStyle(color: Colors.white70),) ,):
                                        const SizedBox(width: 0,height: 0,)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {

                              if(trueCount!=0) {
                                if (isSelected[index]) {
                                  setState(() {
                                    if(!usergroups[index].muted){
                                      unMutedSelected.remove(index);

                                    }
                                    if(!usergroups[index].pinned){
                                      unPinnedSelected.remove(index);
                                    }
                                    isSelected[index] = false;
                                    trueCount--;
                                  });
                                }
                                else{
                                  setState(() {
                                    if(!usergroups[index].muted){
                                      unMutedSelected.add(index);
                                    }
                                    if(!usergroups[index].pinned){
                                      unPinnedSelected.add(index);
                                    }

                                    isSelected[index]=true;
                                    trueCount++;
                                  });
                                }

                              }
                              else{
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return GroupWindow(groupName: usergroup.name, groupPhoto: usergroup.imageUrl, backgroundImage: usergroup.backgroundImage, groupId: usergroup.groupId);
                                },));
                              }
                            },
                            onLongPress: (){
                                  if(isSelected[index]){
                                    setState(() {
                                      if(!usergroups[index].muted){
                                        unMutedSelected.remove(index);

                                      }
                                      if(!usergroups[index].pinned){
                                        unPinnedSelected.remove(index);
                                      }
                                      isSelected[index]=false;
                                      trueCount--;
                                    });

                                  }
                                  else{
                                    setState(() {
                                      if(!usergroups[index].muted){
                                        unMutedSelected.add(index);

                                      }
                                      if(!usergroups[index].pinned){
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
                        },

                  );
              }
                else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }
                else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
            builder: (context) => SearchGroup(usergroup: usergroups),
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
