import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:realtime_messaging/Services/remote_services.dart';
import 'package:realtime_messaging/screens/search_contacts.dart';
import 'package:realtime_messaging/screens/user_info.dart';

import '../Models/users.dart';
import '../Services/users_remote_services.dart';

class OtherUserProfilePage extends StatefulWidget {
  final String? chatId;
  final String? userId;
  const OtherUserProfilePage({Key? key, this.chatId, this.userId})
      : super(key: key);

  @override
  State<OtherUserProfilePage> createState() => _OtherUserProfilePageState();
}

class _OtherUserProfilePageState extends State<OtherUserProfilePage> {
  String id = '';
  bool userLoaded = false;
  Users? user;
  int index = -1;
  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getId() {
    if (widget.userId != null) {
      id = widget.userId!;
    } else if (widget.chatId!.startsWith(cid)) {
      id = widget.chatId!.substring(cid.length);
    } else {
      id = widget.chatId!.substring(0, widget.chatId!.length - cid.length);
    }
  }

  void getUser() async {
    getId();
    try {
      user = await RemoteServices()
          .getSingleUser(id)
          .catchError((e) => throw Exception('$e'));
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('${e.message}')));
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$e')));
    }
    setState(() {
      userLoaded = true;
      index = savedNumber.indexOf(user!.phoneNo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (userLoaded)
            ? Container(
                height: double.infinity,
                color: Colors.cyan,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        BackButton(),
                      ],
                    ),
                    Spacer(),
                    Stack(children: [
                      ClipOval(
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ClipOval(
                              child: Material(
                                child: Image(
                                  image: NetworkImage(user!.photoUrl!),
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: ClipOval(
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            color: Colors.white,
                            child: ClipOval(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                color: (user!.isOnline!)
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      )
                    ]),
                    Spacer(),
                    (!user!.isOnline!)
                        ? Text(
                            'last seen: ${user!.lastOnline!.hour}:${(user!.lastOnline!.minute) / 10}${(user!.lastOnline!.minute) % 10} on ${user!.lastOnline!.day}/${user!.lastOnline!.month}/${user!.lastOnline!.year}')
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          ),
                    Text(
                      (index != -1) ? savedUsers[index] : user!.name!,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${user!.phoneNo.substring(0, 3)} ${user!.phoneNo.substring(3)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    Container(
                      color: Colors.white70,
                      width: 350,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          user!.about!,
                          style: const TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    Spacer()
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 5,
                ),
              ));
  }
}
