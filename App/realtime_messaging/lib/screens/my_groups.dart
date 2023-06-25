import 'package:flutter/material.dart';
import 'package:realtime_messaging/Models/userGroups.dart';
import 'package:realtime_messaging/screens/search_contacts.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import '../Models/groups.dart';
import '../Services/groups_remote_services.dart';
import '../Services/users_remote_services.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final RemoteServices _remoteServices = RemoteServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<UserGroup>>(
        stream: _remoteServices.getUserGroups(cid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<UserGroup> usergroups = snapshot.data!;
            if (usergroups.isEmpty) {
              return const Center(
                child: Text('No groups to display.'),
              );
            }
            final List<UserGroup> sortedusergroups =[... usergroups.where((element) => element.pinned), ... usergroups.where((element) => !element.pinned)];
            return ListView.builder(
              itemCount: usergroups.length,
              itemBuilder: (context, index) {
                final UserGroup usergroup = sortedusergroups[index];
                return FutureBuilder<Group>(
                  future: GroupsRemoteServices().getSingleGroup(usergroup.groupId),
                  builder: (context, snapshot) {
                    final group = snapshot.data!;
                    return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(group.imageUrl!),
                  ),
                  title: Text(group.name),
                  subtitle: Text(group.lastMessage ?? ""),
                  trailing: Text((group.lastMessageTime==null?"":"${group.lastMessageTime!.hour}:${group.lastMessageTime!.minute}")),
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