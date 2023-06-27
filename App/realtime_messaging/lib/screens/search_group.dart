
import 'package:flutter/material.dart';

import '../Models/userGroups.dart';
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
        child: TextField(
          controller: _searchController,
          onChanged: (e) => {
            setState(() {
              // searchGroup=[];
              // for (int i = 0; i < widget.usergroup.length; i++) {
              //   if (widget.usergroup[i].name
              //       .toLowerCase()
              //       .contains(e.toLowerCase())) {
              //     searchGroup.add(widget.usergroup[i].name);
              //
              //   }
              // }
            })
          },
          decoration: InputDecoration(
              filled: true,
              hintText: 'Search Groups',
              fillColor: Colors.blue[100],
              prefixIcon: const Icon(
                Icons.search,
                size: 25,
                color: Colors.black,
              ),
              suffixIcon:IconButton(
                onPressed: (){},
                icon: const Icon(Icons.cancel_outlined),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20))),
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
                  onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return GroupWindow(groupName: widget.usergroup[index].name, groupPhoto: widget.usergroup[index].imageUrl, backgroundImage: widget.usergroup[index].backgroundImage, groupId: widget.usergroup[index].groupId);
                      },));

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
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return GroupWindow(groupName: widget.usergroup[index].name, groupPhoto: widget.usergroup[index].imageUrl, backgroundImage: widget.usergroup[index].backgroundImage, groupId: widget.usergroup[index].groupId);
                    },));

                  },

                ):SizedBox()
            ),
          )
        ]
      )
    );
  }
}
