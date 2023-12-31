import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_messaging/screens/chat_window.dart';
import 'package:realtime_messaging/screens/home_page.dart';
import 'package:realtime_messaging/screens/otherUser_profile_page.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'package:realtime_messaging/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Models/users.dart';
import '../Services/users_remote_services.dart';
import '../main.dart';



class SearchContactPage extends StatefulWidget {
  const SearchContactPage({super.key});
  @override
  State<SearchContactPage> createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  List<String> searchedUser = [];
  List<String> searchedNumber = [];
  List<String> appUserNumber = [];
  List<String> blockedBy=[];

  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 50,
          width: 390,
          child: Builder(
            builder: (context) {
              final themeProvider=Provider.of<ThemeProvider>(context,listen: false);
              return TextField(
                controller: _searchController,
                onChanged: (e) => {
                  setState(() {
                    searchedUser = [];
                    searchedNumber = [];
                    for (int i = 0; i < savedUsers.length; i++) {
                      if (savedUsers[i].toLowerCase().contains(e.toLowerCase())) {
                        searchedUser.add(savedUsers[i]);
                        searchedNumber.add(savedNumber[i]);
                      }
                    }
                  })
                },
                decoration: InputDecoration(
                    filled: true,
                    hintText: 'Search Contacts',
                    fillColor:(themeProvider.isDarkMode?const Color.fromARGB(255, 72, 69, 69):Colors.blue[100]),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 25,
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (_searchController.text.isEmpty) {
                          Navigator.pop(context);
                        } else {
                          _searchController.clear();
                        }
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20))),
              );
            }
          ),
        ),
        Flexible(
            child: StreamBuilder<List<Users>>(
          stream: RemoteServices().getUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong !${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data == null) {
              return Center(
                  child: Container(
                padding: const EdgeInsets.all(15),
                child:
                    const Text('App Users from Your contact will appear here'),
              ));
            } else {
              final users = snapshot.data!;

              appUserNumber = users.map((user) => user.phoneNo).toList();
              for(int i=0;i<users.length;i++){
                if(cid==users[i].id){
                  blockedBy=users[i].blockedBy??[];
                  break;
                }
              }

              //debugPrint('$appUserNumber');

              if (_searchController.text.isEmpty) {
                return ListView(
                  children:
                      MergeAppUserAndSendInvite(users, appUserNumber,blockedBy ,context),
                );
              } else {
                return ListView(
                    children: SearchMerge(users, appUserNumber, searchedNumber,
                        searchedUser,blockedBy, context));
              }
            }
          },
        )),
      ],
    ));
  }
}

List<Widget> MergeAppUserAndSendInvite(
    List<Users> users, List<String> appUserNumber,List<String> blockedBy,BuildContext context) {
  List<Widget> returnablelist = [];
  List<Widget> inviteToApp = [];
  void openMessagingApp(String phoneNumber )async {
    String encodedMessage=Uri.encodeComponent('Hey join me on this amazing realtime encrypted messaging app!\n Chatrix \n you can get it from \n https://github.com/shashical/realtime_messaging.git');
    Uri uri=Uri.parse('sms:$phoneNumber?body=$encodedMessage');
    if(await canLaunchUrl(uri)){
      //android
      await launchUrl(uri);
    }
    else{
      //ios
      uri=Uri.parse('sms:00${phoneNumber.substring(3)}?body=$encodedMessage');
      if(await canLaunchUrl(uri)){
        await launchUrl(uri);
      }
      else{
        throw Exception('could not launch uri');
      }


    }
  }
  for (int i = 0; i < savedNumber.length; i++) {
    int index = appUserNumber.indexOf(savedNumber[i]);
    if (index != -1) {
      if (users[index].id != cid) {
        returnablelist.add(ListTile(
          onTap: () async {
            DocumentSnapshot docsnap = await FirebaseFirestore.instance
                .collection('users').doc(cid).collection('userChats').doc('$cid${users[index].id}')
                .get();
            if (docsnap.exists) {
              RemoteServices().updateUser(cid, {'current':docsnap.get('chatId')});
              final result=await Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return ChatWindow(
                    otherUserId: users[index].id,
                    chatId: docsnap.get('chatId'),
                    backgroundImage: docsnap.get('backgroundImage'),
                    exists: true,
                  );
                },
              ));
              RemoteServices().updateUser(cid, {'current':result});
              current=null;
            } else {
              docsnap = await FirebaseFirestore.instance
                  .collection('chats').doc('${users[index].id}$cid')
                  .get();
              if (docsnap.exists) {
                RemoteServices().updateUser(cid, {'current':docsnap.get('id')});
                await Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return ChatWindow(
                      otherUserId: users[index].id,

                      chatId: docsnap.get('id'),
                      //backgroundImage: docsnap.get('backgroundImage'),
                    );
                  },
                ));
                RemoteServices().updateUser(cid, {'current':null});
                current=null;
              } else {
                docsnap = await FirebaseFirestore.instance
                    .collection('chats').doc('$cid${users[index].id}')
                    .get();
                if (docsnap.exists) {
                  RemoteServices().updateUser(cid, {'current':docsnap.get('id')});
                  await Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return ChatWindow(
                        otherUserId: users[index].id,

                        chatId: docsnap.get('id'),
                        //backgroundImage: docsnap.get('backgroundImage'),
                      );
                    },
                  ));
                  RemoteServices().updateUser(cid, {'current':null});
                  current=null;
                } else {

                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return ChatWindow(otherUserId: users[index].id);
                  },
                ));}
              }
            }
          },
          leading: InkWell(
            child: CircleAvatar(
              foregroundImage: NetworkImage(
                !(blockedBy.contains(users[index].id))?'${users[index].photoUrl}':'http://ronaldmottram.co.nz/wp-content/uploads/2019/01/default-user-icon-8.jpg',
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OtherUserProfilePage(
                            userId: users[index].id,
                          )));
            },
          ),
          title: Text(savedUsers[i]),
          subtitle: Text(
            '${users[index].about}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

        ));
      }
    } else {
      inviteToApp.add(ListTile(
        leading: const CircleAvatar(
          foregroundImage: NetworkImage(
              'https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1'),
        ),
        title: Text(savedUsers[i]),
        trailing: TextButton(
          onPressed: ()  {
             openMessagingApp(savedNumber[i]);
          },
          child: const Text(
            'invite',
            style: TextStyle(color: Colors.purple, fontSize: 20),
          ),
        ),
      ));
    }
  }
  if (inviteToApp.isNotEmpty) {
    returnablelist.add(const SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Invite to Chatrix',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      ),
    ));
    returnablelist.addAll(inviteToApp);
  }
  return returnablelist;
}

List<Widget> SearchMerge(
    List<Users> users,
    List<String> appUserNumber,
    List<String> searchedNumber,
    List<String> searchedUsers,
    List<String> blockedBy,
    BuildContext context,
   ) {
  void openMessagingApp(String phoneNumber )async {
    String encodedMessage=Uri.encodeComponent('Hey join me on this amazing encrypted realtime messaging app -- \'Chatrix\'\nYou can get it from https://github.com/shashical/realtime_messaging.git');
     Uri uri=Uri.parse('sms:$phoneNumber?body=$encodedMessage');
    if(await canLaunchUrl(uri)){
      //android
      await launchUrl(uri);
    }
    else{
      //ios
      uri=Uri.parse('sms:00${phoneNumber.substring(3)}?body=$encodedMessage');
      if(await canLaunchUrl(uri)){
        await launchUrl(uri);
      }
      else{
        throw Exception('could not launch uri');
      }


    }
  }
  List<Widget> returnablelist = [];
  List<Widget> inviteToApp = [];
  for (int i = 0; i < searchedNumber.length; i++) {
    int index = appUserNumber.indexOf(searchedNumber[i]);
    if (index != -1) {
      if (users[index].id != cid) {
        returnablelist.add(ListTile(
          onTap: () async {
            DocumentSnapshot docsnap = await FirebaseFirestore.instance
                .collection('users').doc(cid).collection('userChats').doc('$cid${users[index].id}')
                .get();
            if (docsnap.exists) {
              RemoteServices().updateUser(cid, {'current':docsnap.get('chatId')});
              final result=await Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return ChatWindow(
                    otherUserId: users[index].id,
                    chatId: docsnap.get('chatId'),
                    backgroundImage: docsnap.get('backgroundImage'),
                    exists: true,
                  );
                },
              ));
              RemoteServices().updateUser(cid, {'current':result});
              current=null;
            } else {
              docsnap = await FirebaseFirestore.instance
                  .collection('chats').doc('${users[index].id}$cid')
                  .get();
              if (docsnap.exists) {
                RemoteServices().updateUser(cid, {'current':docsnap.get('id')});
                await Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return ChatWindow(
                      otherUserId: users[index].id,

                      chatId: docsnap.get('id'),
                      //backgroundImage: docsnap.get('backgroundImage'),
                    );
                  },
                ));
                RemoteServices().updateUser(cid, {'current':null});
                current=null;
              } else {
                docsnap = await FirebaseFirestore.instance
                    .collection('chats').doc('$cid${users[index].id}')
                    .get();
                if (docsnap.exists) {
                  RemoteServices().updateUser(cid, {'current':docsnap.get('id')});
                  await Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return ChatWindow(
                        otherUserId: users[index].id,

                        chatId: docsnap.get('id'),
                        //backgroundImage: docsnap.get('backgroundImage'),
                      );
                    },
                  ));
                  RemoteServices().updateUser(cid, {'current':null});
                  current=null;
                } else {

                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return ChatWindow(otherUserId: users[index].id);
                    },
                  ));}
              }
            }
          },

          leading: InkWell(
            child: CircleAvatar(
              foregroundImage: NetworkImage((blockedBy.contains(users[index].id))?'${users[index].photoUrl}':'http://ronaldmottram.co.nz/wp-content/uploads/2019/01/default-user-icon-8.jpg'),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OtherUserProfilePage(
                            userId: users[index].id,
                          )));
            },
          ),
          title: Text(searchedUsers[i]),
          subtitle: Text(
            '${users[index].about}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ));
      }
    } else {
      inviteToApp.add(ListTile(
        leading: const CircleAvatar(
          foregroundImage: NetworkImage(
              'https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1'),
        ),
        title: Text(searchedUsers[i]),
        trailing: TextButton(
          onPressed: ()  {
            openMessagingApp(searchedNumber[i]);
          },
          child: const Text(
            'Invite',
            style: TextStyle(color: Colors.purple, fontSize: 20),
          ),
        ),
      ));
    }
  }
  if (inviteToApp.isNotEmpty) {
    returnablelist.add(const SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Invite to Chatrix',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w500, color: Colors.grey),
        ),
      ),
    ));
    returnablelist.addAll(inviteToApp);
  }
  return returnablelist;
}
