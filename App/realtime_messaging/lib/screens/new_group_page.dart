
import 'package:flutter/material.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import '../Models/users.dart';
import '../Services/users_remote_services.dart';
import '../main.dart';
import 'group_initialization.dart';

class NewGroupPage extends StatefulWidget {
  const NewGroupPage({Key? key}) : super(key: key);

  @override
  State<NewGroupPage> createState() => _NewGroupPageState();
}
List<String> participantIds=[];
class _NewGroupPageState extends State<NewGroupPage> {
  List<String> searchedUser = [];
  List<String> searchedNumber = [];
  List<String> appUserNumber = [];
  List<String> appUserIds=[];
  List<Users> users=[];
  int cui=-1;

  @override
  void initState(){
    super.initState();
    participantIds=[];


  }

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
            child: TextField(
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
                  fillColor: Colors.blue[100],
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (_searchController.text.isEmpty) {
                        Navigator.pop(context);
                      }
                      else{
                        setState(() {
                          _searchController.text='';
                        });

                      }
                    },
                    icon: const Icon(Icons.cancel_outlined),
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
                return Text('Something went wrong !${snapshot.error}');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data == null) {
                return Center(
                    child: Container(
                  padding: const EdgeInsets.all(15),
                  child: const Text(
                      'App Users from Your contact will appear here'),
                ));
              } else {
                users = snapshot.data!;

                appUserNumber = users.map((user) => user.phoneNo).toList();
                appUserIds = users.map((user) => user.id).toList();
                cui = appUserIds.indexOf(cid);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    (participantIds.isEmpty)?const SizedBox(height: 0,):
                    Flexible(
                      flex: 1,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                          itemCount: participantIds.length,
                          itemBuilder: (context, index) => InkWell(
                                child: Stack(
                                  children: [
                                    const SizedBox(width: 60,height: 30,),
                                    Positioned(
                                      top: 7,
                                      left: 10,
                                      child: CircleAvatar(
                                        foregroundImage: NetworkImage(users[
                                                appUserIds
                                                    .indexOf(participantIds[index])]
                                            .photoUrl!),
                                      ),
                                    ),
                                    const Positioned(
                                        bottom:10,
                                        right: 1,
                                        child: Icon(Icons.cancel,size: 15,color: Colors.grey,))
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    participantIds.remove(participantIds[index]);
                                  });
                                },
                              )),
                    ),
                    Flexible(
                      flex:13,
                      fit:FlexFit.tight,
                      child: ListView(
                          children: (_searchController.text.isEmpty)
                              ? usersPresentList(users, appUserNumber, context,
                                  (index) {
                                  setState(() {
                                    if (participantIds
                                        .contains(users[index].id)) {
                                      participantIds.remove(users[index].id);
                                    } else {
                                      participantIds.add(users[index].id);
                                    }
                                  });
                                })
                              : SearchMerge(users, appUserNumber, searchedNumber,
                                  searchedUser, context, (index) {
                                  setState(() {
                                    if (participantIds
                                        .contains(users[index].id)) {
                                      participantIds.remove(users[index].id);
                                    } else {
                                      participantIds.add(users[index].id);
                                    }
                                  });
                                })),
                    ),
                  ],
                );
              }
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (participantIds.isEmpty) {
            showDialog(
                context: (context),
                builder: (context) => AlertDialog(
                      title: const Text('Select atleast 1'),
                      content: const Text(
                          'please select atleast one participant to form group'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: const Text('Ok'))
                      ],
                    )
            );
           }
          else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>
                      GroupInitialization(participantIds: participantIds, users: users,index:cui, appUserIds: appUserIds,)));
          }
         },// child: const Icon(Icons.arrow_forward

        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}

List<Widget> usersPresentList(List<Users> users, List<String> appUserNumber,
    BuildContext context, Function(int) onpress) {
  List<Widget> returnablelist = [];
  for (int i = 0; i < savedNumber.length; i++) {
    int index = appUserNumber.indexOf(savedNumber[i]);
    if (index != -1) {
      if (users[index].id != cid) {
        returnablelist.add(ListTile(
          tileColor: participantIds.contains(users[index].id)?Colors.blue.withOpacity(0.5):null,
          leading: InkWell(
            child: CircleAvatar(
              foregroundImage: NetworkImage('${users[index].photoUrl}'),
            ),
            onTap: () {
              onpress(index);
            },
          ),
          title: Text(savedUsers[i]),
          subtitle: Text(
            '${users[index].about}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            onpress(index);
          },
        ));
      }
    }
  }

  return returnablelist;
}

List<Widget> SearchMerge(
    List<Users> users,
    List<String> appUserNumber,
    List<String> searchedNumber,
    List<String> searchedUsers,
    BuildContext context,
    Function(int) onpress) {
  List<Widget> returnablelist = [];
  for (int i = 0; i < searchedNumber.length; i++) {
    int index = appUserNumber.indexOf(searchedNumber[i]);
    if (index != -1) {
      if (users[index].id != cid) {
        returnablelist.add(ListTile(
          tileColor: participantIds.contains(users[index].id)?Colors.blue.withOpacity(0.5):null,
          leading: InkWell(
            child: CircleAvatar(
              foregroundImage: NetworkImage('${users[index].photoUrl}'),
            ),
            onTap: () {
              onpress(index);
            },
          ),
          title: Text(searchedUsers[i]),
          subtitle: Text(
            '${users[index].about}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: (){
            onpress(index);
          },
        ));
      }
    }
  }

  return returnablelist;
}
