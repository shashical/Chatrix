import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_messaging/screens/user_info.dart';

import '../Models/users.dart';
import '../Services/users_remote_services.dart';
import '../main.dart';
import '../theme_provider.dart';

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
      user = await RemoteServices().getSingleUser(id).catchError((e) => throw Exception('$e'));
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
          ? Stack(
              children: [
                Builder(
                  builder: (context) {
                    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: (themeProvider.isDarkMode?[
                            const Color.fromARGB(255, 61, 84, 88),
                            const Color.fromARGB(255, 86, 44, 70),
                          ]:[
                            const Color.fromARGB(255, 147, 203, 216),
                            const Color.fromARGB(255, 200, 104, 163),
                          ]),
                        ),
                      ),
                    );
                  }
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, left: 20),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(user!.photoUrl!),
                          ),

                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: (user!.isOnline!)? Colors.green:Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        (index != -1) ? savedUsers[index] : user!.name!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${user!.phoneNo.substring(0, 3)} ${user!.phoneNo.substring(3)}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Builder(
                        builder: (context) {
                          final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: (themeProvider.isDarkMode?Color.fromARGB(255, 72, 69, 69):Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'About',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  user!.about??'',
                                  style: TextStyle(
                                    fontSize: 18,
                                    // color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          (user!.isOnline!)
                              ? 'Online Now'
                              : 'Last seen: ${(user!.lastOnline!.hour) ~/ 10}${user!.lastOnline!.hour%10}:${(user!.lastOnline!.minute) ~/ 10}${(user!.lastOnline!.minute) % 10} on ${user!.lastOnline!.day}/${user!.lastOnline!.month}/${user!.lastOnline!.year}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 5,
              ),
            ),
    );
  }
}



