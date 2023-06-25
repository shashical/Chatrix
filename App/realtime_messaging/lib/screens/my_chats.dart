import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/chats.dart';
import 'package:realtime_messaging/Models/userChats.dart';
import 'package:realtime_messaging/Services/chats_remote_services.dart';
import 'package:realtime_messaging/screens/search_contacts.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import '../Services/chats_remote_services.dart';
import '../Services/users_remote_services.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final RemoteServices _usersremoteServices = RemoteServices();
  final ChatsRemoteServices _chatsremoteServices = ChatsRemoteServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<UserChat>>(
        stream: _usersremoteServices.getUserChats(cid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<UserChat> userchats = snapshot.data!;
            if (userchats.isEmpty) {
              return Center(
                child: Text('No chats to display.'),
              );
            }
            final List<UserChat> sorteduserchats = [
              ...userchats.where((element) => element.pinned),
              ...userchats.where((element) => !element.pinned)
            ];
            return ListView.builder(
              itemCount: userchats.length,
              itemBuilder: (context, index) {
                final UserChat userchat = sorteduserchats[index];
                if (userchat.deleted) {
                  return SizedBox();
                }
                return FutureBuilder<Chat>(
                  future: _chatsremoteServices.getSingleChat(userchat.chatId),
                  builder: (context, snapshot) {
                    final chat = snapshot.data!;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(userchat.recipientPhoto),
                      ),
                      title: Text(userchat.recipientPhoneNo),
                      subtitle: Text(chat.lastMessage ?? ""),
                      trailing: Text((chat.lastMessageTime == null
                          ? ""
                          : "${chat.lastMessageTime!.hour}" +
                              ":" +
                              "${chat.lastMessageTime!.minute}")),
                      onTap: () {},
                    );
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan.shade800,
        child: Icon(Icons.search),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => SearchContactPage(),
            shape: RoundedRectangleBorder(
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
