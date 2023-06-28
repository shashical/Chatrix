
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realtime_messaging/main.dart';
import 'package:realtime_messaging/screens/group_window.dart';
import 'package:realtime_messaging/screens/home_page.dart';
import 'package:realtime_messaging/screens/new_group_page.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'dart:io';
import '../Models/groups.dart';
import '../Models/userGroups.dart';
import '../Models/users.dart';
import '../Services/groups_remote_services.dart';
import '../Services/users_remote_services.dart';

class GroupInitialization extends StatefulWidget {
  final List<String> participantIds;
  final List<Users> users;
  final int index;
  final List<String> appUserIds;
  const GroupInitialization({Key? key, required this.participantIds, required this.users, required this.index, required this.appUserIds}) : super(key: key);

  @override
  State<GroupInitialization> createState() => _GroupInitializationState();
}

class _GroupInitializationState extends State<GroupInitialization> {
  File? _image;
  String? imageUrl;
  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    }
    final imageTemp = File(image.path);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {
      _image = imageTemp;
    });
  }
final TextEditingController _groupNameController=TextEditingController();
  final String groupid = "${DateTime
      .now()
      .microsecondsSinceEpoch}";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('New Group'),
            Text('add subject'),
          ],
        )

      ),
      body:Column(
        children: [
          const SizedBox(height: 10,),
          Row(
            children: [
              const SizedBox(width: 10,),
              GestureDetector(
                onTap: () {
                  SimpleDialog alert =
                  SimpleDialog(
                  title: const Text(
                  "Choose an action"),
                  children: [
                    SimpleDialogOption(
                      onPressed: () async {
                        await getImage(ImageSource.gallery);
                        if(_image!=null){
                          imageUrl=await GroupsRemoteServices().uploadNewImage(_image!,groupid);
                        }
                        },
                      child: const Row(
                        children:[
                            Icon(CupertinoIcons.photo,color: Colors.blue,),
                            SizedBox(width: 8.0),
                            Text("Pick from gallery",
                              style: TextStyle(
                                    fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                        ),
                                            ),
                                        ],),),
                        SimpleDialogOption(
                          onPressed: () async{
                            await getImage(ImageSource.camera);
                            if(_image!=null){
                              imageUrl=await GroupsRemoteServices().uploadNewImage(_image!,groupid);
                            }

                            },
                          child: const Row(
                              children: [
                                Icon(Icons.camera_alt,color: Colors.green,),
                                SizedBox(width: 8.0),
                                Text("Capture from camera",
                                  style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              ),
                                              ],
                                              ),
                                              ),
                                            ],);
                            showDialog(context: context,builder: (context) =>
                              alert,barrierDismissible: true,);
                            },
                child: Container(
                  padding: const EdgeInsets.only(bottom:10 ),
                  width: 50,
                  height:50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image: _image != null
                        ? DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    )
                        :const DecorationImage(
                        image: NetworkImage('https://geodash.gov.bd/uploaded/people_group/default_group.png'),fit: BoxFit.cover)

                  ),
                ),
              ),
               const SizedBox(width: 15,),
               SizedBox(
                 width: 300,
                 child: TextField(
                  controller: _groupNameController,
                   decoration: InputDecoration(
                     filled:true,
                     fillColor: Colors.cyan[100],
                     hintText: 'Enter a subject to group',
                     border: OutlineInputBorder(
                       borderSide: BorderSide.none,
                         borderRadius: BorderRadius.circular(20)
                     )
                   ),

              ),
               )
            ],
          ),
          Container(
            color: Colors.grey,
            height: 20,
          ),
          Text('Participants: ${participantIds.length}'),
          Flexible(
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,

                ),
                itemCount: participantIds.length,
                itemBuilder: (context,index){
                  int ri=widget.appUserIds.indexOf(participantIds[index]);
                  int savedIndex=savedNumber.indexOf(widget.users[ri].phoneNo);
                  return Column(
                  children: [
                    CircleAvatar(
                      foregroundImage: NetworkImage(widget.users[ri].photoUrl!),
                    ),
                    Text(savedUsers[savedIndex],
                    maxLines:1,
                    overflow: TextOverflow.ellipsis,),
                  ],
                );
                }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(_groupNameController.text.isEmpty){
            showDialog(context: context, builder: (context)=> AlertDialog(
              title: const Text('please provide subject to continue'),
              actions: [
                ElevatedButton(onPressed: (){
                  Navigator.of(context,rootNavigator: true).pop();
                }, child: const Text('Ok'))
              ],
            ));
          }
          else {
            participantIds.add(cid);

           await  GroupsRemoteServices().setGroups(Group(
                id: groupid,
                participantIds: participantIds,
                creationTimestamp: DateTime.now(),
                createdBy: widget.users[widget.index].phoneNo,
                admins: [cid]));
            for (var i in participantIds) {
              RemoteServices().setUserGroup(
                  i,
                  UserGroup(
                      id: groupid,
                      groupId: groupid,
                      exited: false,
                      pinned: false,
                      name: _groupNameController.text,
                      imageUrl:imageUrl??
                      ' https://geodash.gov.bd/uploaded/people_group/default_group.png',
                      backgroundImage:
                      "https://wallup.net/wp-content/uploads/2018/03/19/580162-pattern-vertical-portrait_display-digital_art.jpg"));
            }
         final    nav=Navigator.of(context);
            nav.pop();
            nav.pop();
            nav.push(
                MaterialPageRoute(builder: (context)=>
                GroupWindow(groupName: _groupNameController.text,
                    groupPhoto:
                imageUrl??'https://geodash.gov.bd/uploaded/people_group/default_group.png',
                    backgroundImage: 'https://wallup.net/wp-content/uploads/2018/03/19/580162-pattern-vertical-portrait_display-digital_art.jpg',
                    groupId: groupid)));
          }

        },
        child: const Icon(Icons.done),
      ),

    );
  }
}


