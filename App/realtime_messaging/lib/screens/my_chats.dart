import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/chats.dart';
import 'package:realtime_messaging/Models/userChats.dart';
import 'package:realtime_messaging/Services/chats_remote_services.dart';
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
  final ChatsRemoteServices _chatsremoteServices = ChatsRemoteServices();
  int index=-1;

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
            return ListView.builder(
              itemCount: userchats.length,
              itemBuilder: (context, index) {
                final UserChat userchat = userchats[index];
                if (userchat.deleted) {
                  return const SizedBox();
                }
                return FutureBuilder<Chat>(
                  future: _chatsremoteServices.getSingleChat(userchat.chatId),
                  builder: (context, snapshot) {
                    final chat = snapshot.data!;
                    index=savedNumber.indexOf(userchat.recipientPhoneNo);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(userchat.recipientPhoto),
                      ),
                      title: Text((index!=-1)?savedUsers[index]:userchat.recipientPhoneNo),
                      subtitle: Text(chat.lastMessage ?? ""),
                      trailing: Text((chat.lastMessageTime == null
                          ? ""
                          : "${chat.lastMessageTime!.hour}:${chat.lastMessageTime!.minute/10}${chat.lastMessageTime!.minute%10}")),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
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
