import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:realtime_messaging/Services/remote_services.dart';

import '../Models/users.dart';
List<String> savedNumber=[];
List<String> savedUsers=[];
class SearchContactPage extends StatefulWidget {
  const SearchContactPage({super.key});
  @override
  State<SearchContactPage> createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  List<Contact> contacts = [];

  bool isg = false;
  bool contactsFetched = false;

  List<String> searchedUser=[];
  List<String> searchedNumber=[];
  List<String> appUserNumber=[];
  Set<String> helper={};


  @override
  void initState() {
    super.initState();
    FlutterContacts.config.returnUnifiedContacts=true;
    getContactPermission();


  }


  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContact();
      setState(() {
        isg = true;
      });
    } else {
      await Permission.contacts.request();
      if (await Permission.contacts.isGranted) {
        fetchContact();

        setState(() {
          isg = true;
        });
      }
    }
  }

  void fetchContact() async {
    contacts = await FlutterContacts.getContacts(withProperties: true);
    setState(() {

      contactsFetched = true;

      //debugPrint("${contactsFetched}");


      for(int i=0;i<contacts.length;i++){
        int a=helper.length;
        if(contacts[i].phones.isNotEmpty){
          helper.add(contacts[i].phones[0].normalizedNumber);
          if(helper.length>a){
            savedNumber.add(contacts[i].phones[0].normalizedNumber);
            savedUsers.add(contacts[i].displayName);
          }
        }
      }
      //debugPrint("${savedNumber}");
    });
  }
  TextEditingController _searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:(isg==false)?Center(
        child: Text('Please Restart the App and provide required permission!',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize:  32,
        ),),
      ):(contactsFetched)?
      Column(
        children: [
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 50,
            width: 390,
            child: TextField(
              controller:_searchController,

              onChanged: (e)=>{
                setState((){
                  searchedUser=[];
                  searchedNumber=[];
                  for( int i=0;i<savedUsers.length;i++){
                    if(savedUsers[i].toLowerCase().contains(e.toLowerCase())){
                      searchedUser.add(savedUsers[i]);
                      searchedNumber.add(savedNumber[i]);
                    }
                  }
                })
              },
              decoration:   InputDecoration(
                filled: true,
                hintText: 'Search Contacts',
                fillColor: Colors.blue[100],
                prefixIcon: Icon(Icons.search,
                    size :25,
                  color: Colors.black,
                ),
                suffixIcon: PopupMenuButton(
                  itemBuilder: (context)=>[
                    PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.group),
                            Text('Invite a friend',)
                          ],
                        ),
                    onTap: (){},),
                    PopupMenuItem(child: Row(
                      children: [
                        Icon(Icons.arrow_back),
                        Text('Go back')
                      ],
                    ),
                    onTap: (){},)

                  ],),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20)
                )
              ),

            ),
          ),
          Flexible(
              child:StreamBuilder<List<Users>>(
                stream: RemoteServices().getUsers(),
                builder: (context,snapshot){
                  if(snapshot.hasError){
                    return Text('Something went wrong !${snapshot.error}');
                  }
                  else if(snapshot.connectionState==ConnectionState.waiting){
                    return const Center(
                    child: CircularProgressIndicator(),);
                  }
                  else if(snapshot.data==null){
                    return Center(
                      child: Container(
                      padding: EdgeInsets.all(15),
                      child: Text('App Users from Your contact will appear here'),
    ));
                  }
                  else {
                    final users = snapshot.data!;

                      appUserNumber=users.map((user) =>user.phoneNo).toList();


                    if(_searchController.text.isEmpty) {
                      return ListView(
                        children: MergeAppUserAndSendInvite(users, appUserNumber),
                      );
                      }

                    else{

                      return ListView(
                        children: SearchMerge(users, appUserNumber, searchedNumber, searchedUser)

                      );

                    }
                  }

                    },
            )
            ),

          ],
          ):
      Center(
          child: CircularProgressIndicator(strokeWidth: 4,color: Colors.deepPurple,))

    );
    }
  }
List<Widget>MergeAppUserAndSendInvite(List<Users> users ,List<String> appUserNumber,){
  List<Widget> returnablelist=[];
  List<Widget> inviteToApp=[];
  for(int i=0;i<savedNumber.length;i++) {
    int index = appUserNumber.indexOf(savedNumber[i]);
    if (index != -1) {
      returnablelist.add(
          ListTile(

            leading: CircleAvatar(
              foregroundImage: NetworkImage('${users[index].photoUrl}'
              ),

            ),
            title: Text(savedUsers[i]),
            subtitle: Text('${users[index].about}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
      );
    }
    else {
      inviteToApp.add(
          ListTile(
            leading: CircleAvatar(foregroundImage: NetworkImage('https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1'),),
            title: Text('${savedUsers[i]}'),
            trailing: TextButton(
              onPressed: () {},
              child: Text('invite',
                style: TextStyle(color: Colors.purple, fontSize: 20),),
            ),
          )
      );
    }
  }
    if(inviteToApp.isNotEmpty){
      returnablelist.add(SizedBox(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text('Invite to Chatrix',
        style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.grey),),
      ),));
      returnablelist.addAll(inviteToApp);
    }
    return returnablelist;


}

List<Widget> SearchMerge(List<Users>users,List<String>appUserNumber,List<String>searchedNumber,List<String>searchedUsers){
  List<Widget> returnablelist=[];
  List<Widget> inviteToApp=[];
  for(int i=0;i<searchedNumber.length;i++) {
    int index = appUserNumber.indexOf(searchedNumber[i]);
    if (index != -1) {
      returnablelist.add(
          ListTile(

            leading: CircleAvatar(
              foregroundImage: NetworkImage('${users[index].photoUrl}'
              ),

            ),
            title: Text(searchedUsers[i]),
            subtitle: Text('${users[index].about}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
      );
    }
    else {
      inviteToApp.add(
          ListTile(
            leading: CircleAvatar(foregroundImage: NetworkImage('https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1'),),
            title: Text(searchedUsers[i]),
            trailing: TextButton(
              onPressed: () {},
              child: Text('invite',
                style: TextStyle(color: Colors.purple, fontSize: 20),),
            ),
          )
      );
    }
  }
  if(inviteToApp.isNotEmpty){
    returnablelist.add(SizedBox(child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text('Invite to Chatrix',
        style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.grey),),
    ),));
    returnablelist.addAll(inviteToApp);
  }
  return returnablelist;
}