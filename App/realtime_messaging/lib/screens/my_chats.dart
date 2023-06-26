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
            isSelected=List.filled(userchats.length,false);
            final List<UserChat> sorteduserchats = [
              ...userchats.where((element) => element.pinned),
              ...userchats.where((element) => !element.pinned)
            ];

            return ListView.builder(
              itemCount: userchats.length,
              itemBuilder: (context, index) {
                final UserChat userchat = sorteduserchats[index];
                if (userchat.deleted) {
                  return const SizedBox();
                }
                return FutureBuilder<Chat>(
                  future: _chatsremoteServices.getSingleChat(userchat.chatId),
                  builder: (context, snapshot) {
                    final chat = snapshot.data!;
                    final ind=savedNumber.indexOf(userchat.recipientPhoneNo);
                    return ListTile(
                      leading:Stack(
                        children:[
                          CircleAvatar(
                          backgroundImage: NetworkImage(userchat.recipientPhoto),
                        ),
                          (isSelected[index])?
                          const Positioned(
                            bottom: 1,
                              right: 5,
                              child: Icon(Icons.check_circle,size: 16,color: Colors.cyan,)):
                          const SizedBox(height: 0,width: 0,)
                        ]
                      ),
                      title: Text((index!=-1)?savedUsers[ind]:userchat.recipientPhoneNo),
                      subtitle: Text(chat.lastMessage ?? ""),
                      trailing: Text((chat.lastMessageTime == null
                          ? ""
                          : "${chat.lastMessageTime!.hour}:${chat.lastMessageTime!.minute/10}${chat.lastMessageTime!.minute%10}")),
                      onTap: () {
                        if(isSelected[index]){
                          setState(() {
                            isSelected[index]=false;
                          });
                        }
                      },
                      onLongPress: (){
                        if(isSelected[index]){
                          setState(() {
                            isSelected[index]=false;
                          });

                        }
                        else{
                          setState(() {
                            isSelected[index]=true;
                          });
                        }
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
