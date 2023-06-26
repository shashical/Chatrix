import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/userChats.dart';
import 'package:realtime_messaging/main.dart';
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
                if (userchat.deleted) {
                  return const SizedBox();
                }
                else {
                  final ind = savedNumber.indexOf(userchat.recipientPhoneNo);
                  return ListTile(
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
                    subtitle: Text(userchat.lastMessage ?? ""),
                    trailing: Text((userchat.lastMessageTime == null
                        ? ""
                        : "${userchat.lastMessageTime!.hour}:${userchat
                        .lastMessageTime!.minute / 10}${userchat
                        .lastMessageTime!.minute % 10}")),
                    onTap: () {
                      if (isSelected[index]) {
                        setState(() {
                          isSelected[index] = false;
                        });
                      }
                    },
                    onLongPress: () {
                      if (isSelected[index]) {
                        setState(() {
                          isSelected[index] = false;
                        });
                      }
                      else {
                        setState(() {
                          isSelected[index] = true;
                        });
                      }
                    },
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
