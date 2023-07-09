
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_messaging/screens/home_page.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'package:realtime_messaging/theme_provider.dart';

import '../Models/userGroups.dart';
import '../Services/users_remote_services.dart';
import 'group_info_page.dart';
import 'group_window.dart';

class SearchGroup extends StatefulWidget {
 final  List<UserGroup> usergroup;
   const SearchGroup({Key? key,required this.usergroup}) : super(key: key);

  @override
  State<SearchGroup> createState() => _SearchGroupState();
}

class _SearchGroupState extends State<SearchGroup> {
  final TextEditingController _searchController=TextEditingController();
  //List<String> searchGroup=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
        const SizedBox(
        height: 20,
         width: double.infinity,
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

                  })
                },
                decoration: InputDecoration(
                    filled: true,
                    hintText: 'Search Group',
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
            child: ListView.builder(itemCount: widget.usergroup.length,
                itemBuilder: (context,index)=>
                (_searchController.text.isEmpty)?
                ListTile(
                  leading: InkWell(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.usergroup[index].imageUrl),
                    ),
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupInfoPage(groupId: widget.usergroup[index].groupId,userGroupId: widget.usergroup[index].id,)));
                    },
                  ),
                  title: Text(widget.usergroup[index].name),
                  subtitle: Text(widget.usergroup[index].lastMessage ?? "", maxLines: 1, overflow: TextOverflow.ellipsis,),
                  trailing: Text((widget.usergroup[index].lastMessageTime == null
                      ? ""
                      : "${widget.usergroup[index].lastMessageTime!.hour}:${widget.usergroup[index].lastMessageTime!.minute/10}${widget.usergroup[index].lastMessageTime!.minute%10}")),
                  onTap: () async {
                    RemoteServices().updateUser(cid, {'current':widget.usergroup[index].groupId});
                    final result=await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                          return GroupWindow(
                              groupName: widget.usergroup[index].name,
                              groupPhoto:widget.usergroup[index].imageUrl,
                              backgroundImage: widget.usergroup[index]
                                  .backgroundImage,
                              groupId: widget.usergroup[index].groupId);
                        },));
                    RemoteServices().updateUser(cid, {'current':result});
                    current=null;

                  },

                ):(widget.usergroup[index].name.toLowerCase().contains(_searchController.text.toLowerCase()))?
                ListTile(
                  leading: InkWell(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.usergroup[index].imageUrl),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupInfoPage(groupId: widget.usergroup[index].groupId,userGroupId: widget.usergroup[index].id,)));
                    },
                  ),
                  title: Text(widget.usergroup[index].name),
                  subtitle: Text(widget.usergroup[index].lastMessage ?? "", maxLines: 1, overflow: TextOverflow.ellipsis,),
                  trailing: Text((widget.usergroup[index].lastMessageTime == null
                      ? ""
                      : "${widget.usergroup[index].lastMessageTime!.hour}:${widget.usergroup[index].lastMessageTime!.minute/10}${widget.usergroup[index].lastMessageTime!.minute%10}")),

                    onTap: () async {
                      RemoteServices().updateUser(cid, {'current':widget.usergroup[index].groupId});
                      final result=await Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return GroupWindow(
                                groupName: widget.usergroup[index].name,
                                groupPhoto:widget.usergroup[index].imageUrl,
                                backgroundImage: widget.usergroup[index]
                                    .backgroundImage,
                                groupId: widget.usergroup[index].groupId);
                          },));
                      RemoteServices().updateUser(cid, {'current':result});
                      current=null;

                    

                  },

                ):const SizedBox()
            ),
          )
        ]
      )
    );
  }
}
