import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:realtime_messaging/screens/otherUser_profile_page.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import '../Models/users.dart';
import '../Services/users_remote_services.dart';
import '../main.dart';



class SearchContactPage extends StatefulWidget {
  const SearchContactPage({super.key});
  @override
  State<SearchContactPage> createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  List<Contact> contacts = [];

  bool isg = false;
  bool contactsFetched = false;

  List<String> searchedUser = [];
  List<String> searchedNumber = [];
  List<String> appUserNumber = [];
  TextEditingController _searchController = TextEditingController();

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
                        child: TextField(
                          controller: _searchController,
                          onChanged: (e) => {
                            setState(() {
                              searchedUser = [];
                              searchedNumber = [];
                              for (int i = 0; i < savedUsers.length; i++) {
                                if (savedUsers[i]
                                    .toLowerCase()
                                    .contains(e.toLowerCase())) {
                                  searchedUser.add(savedUsers[i]);
                                  searchedNumber.add(savedNumber[i]);
                                }
                              }
                            })
                          },
                          decoration: InputDecoration(
                              filled: true,
                              hintText: 'Search Contacts',
                              fillColor: Colors.blue[100],
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 25,
                                color: Colors.black,
                              ),
                              suffixIcon: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Row(
                                      children: [
                                        Icon(Icons.group),
                                        Text(
                                          'Invite a friend',
                                        )
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                  PopupMenuItem(
                                    child: const Row(
                                      children: [
                                        Icon(Icons.arrow_back),
                                        Text('Go back')
                                      ],
                                    ),
                                    onTap: () {},
                                  )
                                ],
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                      ),
                      Flexible(
                          child: StreamBuilder<List<Users>>(
                        stream: RemoteServices().getUsers(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                'Something went wrong !${snapshot.error}');
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.data == null) {
                            return Center(
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: const Text(
                                  'App Users from Your contact will appear here'),
                            ));
                          } else {
                            final users = snapshot.data!;

                            appUserNumber =
                                users.map((user) => user.phoneNo).toList();

                            if (_searchController.text.isEmpty) {
                              return ListView(
                                children: MergeAppUserAndSendInvite(
                                    users, appUserNumber, context),
                              );
                            } else {
                              return ListView(
                                  children: SearchMerge(users, appUserNumber,
                                      searchedNumber, searchedUser, context));
                            }
                          }
                        },
                      )),
                    ],
                  )
                );
  }
}

List<Widget> MergeAppUserAndSendInvite(
    List<Users> users, List<String> appUserNumber, BuildContext context) {
  List<Widget> returnablelist = [];
  List<Widget> inviteToApp = [];
  for (int i = 0; i < savedNumber.length; i++) {
    int index = appUserNumber.indexOf(savedNumber[i]);
    if (index != -1) {
      if (users[index].id != cid) {
        returnablelist.add(ListTile(
          leading: InkWell(
            child: CircleAvatar(
              foregroundImage: NetworkImage('${users[index].photoUrl}'),
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
          onPressed: () {},
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
    BuildContext context) {
  List<Widget> returnablelist = [];
  List<Widget> inviteToApp = [];
  for (int i = 0; i < searchedNumber.length; i++) {
    int index = appUserNumber.indexOf(searchedNumber[i]);
    if (index != -1) {
      if (users[index].id != cid) {
        returnablelist.add(ListTile(
          leading: InkWell(
            child: CircleAvatar(
              foregroundImage: NetworkImage('${users[index].photoUrl}'),
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
          onPressed: () {},
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
