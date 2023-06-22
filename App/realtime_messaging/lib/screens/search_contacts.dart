import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:realtime_messaging/Services/remote_services.dart';

import '../Models/users.dart';

class SearchContactPage extends StatefulWidget {
  const SearchContactPage({super.key});
  @override
  State<SearchContactPage> createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> {
  List<Contact> contacts = [];
  bool isg = false;
  bool contactsFetched = false;
  List<String> savedNumber=[];
  List<String> savedUsers=[];
  List<String> searchedUser=[];
  List<String> searchedNumber=[];


  @override
  void initState() {
    super.initState();
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
      savedNumber=contacts.map((contact) => contact.phones[0].normalizedNumber).toList();
      savedUsers=contacts.map((contact)=>contact.displayName).toList();

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
                    ))

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
                    if(_searchController.text.isEmpty) {
                      return ListView(
                        children: users.map((user) =>
                        (savedUsers.contains(user.mobileNo))?
                            ListTile(
                              leading: CircleAvatar(child: Image(image:NetworkImage('${user.photoUrl}')),),
                              title: Text(savedUsers[savedNumber.indexOf(user.mobileNo)]),
                              subtitle: Text('${user.about}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              ),
                            ):const SizedBox(height: 0,width: 0,)
                        ).toList(),

                      );
                    }
                    else{
                      return ListView(
                        children: users.map((user) => (searchedNumber.contains(user.mobileNo))?
                        ListTile(
                          title: Text(searchedUser[searchedNumber.indexOf(user.mobileNo)]),
                        ):const SizedBox(height: 0,width: 0,)
                        ).toList(),
                      );
                    }
                  }

                    },
            )
            )
          ],
          ):
      Center(
          child: CircularProgressIndicator(strokeWidth: 4,color: Colors.deepPurple,))

    );
    }
  }
