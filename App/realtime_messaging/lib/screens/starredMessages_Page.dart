import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_messaging/Services/starred_remote_services.dart';

import '../Models/starredMessages.dart';

class StarredMessagePage extends StatefulWidget {
  const StarredMessagePage({Key? key}) : super(key: key);

  @override
  State<StarredMessagePage> createState() => _StarredMessagePageState();
}

class _StarredMessagePageState extends State<StarredMessagePage> {
  bool isSearchOn=false;
  TextEditingController _searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.blue.shade800,
                const Color.fromARGB(255, 0, 102, 212),
              ],
            ),
          ),
        ),
        leading: (isSearchOn)?IconButton(onPressed: (){
          _searchController.clear();
          isSearchOn=true;
          setState(() {

          });
        },
            icon: const Icon(Icons.arrow_back))
            :const BackButton(),
        title:(isSearchOn)? Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(

            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide.none
                )

              ),
            ),
          ),
        ): Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          const Text('Starred Messages'),
            IconButton(onPressed: (){
              setState(() {
                isSearchOn=true;
              });
            }, icon: const Icon(CupertinoIcons.search))
        ],),
      ),
      body: Container(
        child: Flexible(
          child: StreamBuilder<List<StarredMessage>>(
            stream: StarredMessageRemoteServices().getStarredMessages(),
            builder: ((context,snapshot){
              if(snapshot.hasData){
                final starredmessages=snapshot.data?.reversed.toList();
                return ListView.builder(
                    itemCount:starredmessages?.length ,
                    itemBuilder: (context,index)=>GestureDetector(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width*0.7,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CircleAvatar(
                                        foregroundImage: NetworkImage(starredmessages![index].senderPhoto),
                                      ),
                                    ),
                                    Text(starredmessages[index].senderPhoneNo),
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(CupertinoIcons.play_arrow_solid),
                                    ),
                                    Text((starredmessages[index].isGroup)?starredmessages[index].groupName!:starredmessages[index].recipientPhoneNo!),

                                  ],
                                ),
                              ),
                              Text('${starredmessages[index].timestamp.day}/${starredmessages[index].timestamp.month}/${starredmessages[index].timestamp.year}'),
                            ],
                          )
                          
                        ],
                      ),
                    ));

              }
              else{
                return const SizedBox();
              }
            }),
          ),
        ),
      ),
    );
  }
}
