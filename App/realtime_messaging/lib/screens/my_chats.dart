import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/chats.dart';
import 'package:realtime_messaging/Models/userChats.dart';
import 'package:realtime_messaging/screens/search_contacts.dart';
import 'package:realtime_messaging/screens/user_info.dart';

import '../Models/users.dart';
import '../Services/remote_services.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final RemoteServices _remoteServices = RemoteServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: StreamBuilder<List<UserChat>>(
        stream: _remoteServices.getUserChats(cid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<UserChat> userchats = snapshot.data!;

            if (userchats.isEmpty) {
              return Center(
                child: Text('No chats to display.'),
              );
            }

            return ListView.builder(
              itemCount: userchats.length,
              itemBuilder: (context, index) {
                final UserChat userchat = userchats[index];

                return FutureBuilder<Chat>(
                  future: _remoteServices.getSingleChat(userchat.chatId),
                  builder: (context, snapshot) {
                    final chat = snapshot.data!;
                    return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userchat.recipientPhoto),
                  ),
                  title: Text(userchat.recipientPhoneNo),
                  subtitle: Text(chat.lastMessage ?? ""),
                  trailing: Text((chat.lastMessageTime==null?"":"${chat.lastMessageTime!.hour}"+":"+"${chat.lastMessageTime!.minute}")),
                  onTap: () {

                  },
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
    );
  }
}