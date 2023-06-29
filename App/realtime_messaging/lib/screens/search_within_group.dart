
import 'package:flutter/material.dart';

class SearchWithinGroup extends StatefulWidget {
  final List<Widget>ListItem;
  final List<List<String>> ListContent;
  const SearchWithinGroup({Key? key, required this.ListItem, required this.ListContent}) : super(key: key);

  @override
  State<SearchWithinGroup> createState() => _SearchWithinGroupState();
}

class _SearchWithinGroupState extends State<SearchWithinGroup> {
  final TextEditingController _searchController=TextEditingController();
  String search='';
  List<int> searchedindex=[];
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
                 searchedindex=[];
                 for(int i=0;i<widget.ListContent.length;i++){
                   if((widget.ListContent[i][0].toLowerCase().contains(e))||(widget.ListContent[i][1].contains(e))){
                     searchedindex.add(i+1);
                   }
                 }

                })
              },
              decoration: InputDecoration(
                  filled: true,
                  hintText: 'Search here',
                  fillColor: Colors.blue[100],
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 25,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    onPressed: (){
                      if(_searchController.text.isEmpty){
                        Navigator.pop(context);
                      }
                      else{
                        setState(() {
                          _searchController.text='';
                        });

                      }
                    },
                    icon: Icon(Icons.cancel_outlined),
                  ),

                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          Flexible(
            child: ListView.builder(
              itemCount: widget.ListItem.length,
                itemBuilder: (context,index){
                  search=_searchController.text;
                  if(search.isEmpty){
                    return widget.ListItem[index];
                  }
                  else{
                    if(searchedindex.contains(index)){
                      return widget.ListItem[index];
                    }
                    else{
                      return SizedBox(
                        height: 0,width: 0,
                      );
                    }

                  }
                }),
          )


        ],
      ),
    );
  }
}
