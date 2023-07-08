import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_messaging/Services/users_remote_services.dart';
import 'package:realtime_messaging/screens/current_user_profile_page.dart';
import 'package:realtime_messaging/screens/new_group_page.dart';
import 'package:realtime_messaging/screens/user_info.dart';
import 'package:realtime_messaging/screens/welcome.dart';

import '../Models/users.dart';
import '../theme_provider.dart';
import 'my_chats.dart';
import 'my_groups.dart';

class HomePage extends StatefulWidget  {
  @override
  _HomePageState createState() => _HomePageState();



}

Users? curUser;
String? current;

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool isLoaded=false;

  final List<Widget> _pages = [
    ChatsPage(),
    GroupsPage(),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    cid=FirebaseAuth.instance.currentUser!.uid;
    getCurUser();
    current=null;
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      RemoteServices().updateUser(cid, {'isOnline':true});
    }
    else {
      RemoteServices().updateUser(cid,{'isOnline':false, 'lastOnline':DateTime.now().toIso8601String()});
    }
  }
  void getCurUser()async{
    curUser=await RemoteServices().getSingleUser(cid);
    setState(() {
      isLoaded=true;
    });
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   // debugPrint('printingcid $cid');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chatrix",
          style: TextStyle(fontFamily: "Caveat", fontSize: 40),
        ),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(itemBuilder: (context)=>[
             PopupMenuItem(
               value: 0,
             onTap: (){
                 WidgetsBinding.instance.addPostFrameCallback((_) {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>const CurrentUserProfilePage()));
                 });
             },
               child: Row(
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage((isLoaded)?curUser!.photoUrl!:
                      "https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1"

                  ),
                ),
                const Text('Account',style: TextStyle(fontSize: 20),)
              ],
            ),),
            PopupMenuItem(value: 1,
                onTap: (){
              WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewGroupPage()));
              });
                },child: const Text('New Group'),
            ),
            PopupMenuItem(value: 3,
            onTap: (){
              WidgetsBinding.instance.addPostFrameCallback((_) async{

                RemoteServices().updateUser(cid, 
                {'token': null,'isOnline':false,'lastOnline':DateTime.now().toIso8601String()},
                );

             await FirebaseAuth.instance.signOut();
             Navigator.pushAndRemoveUntil(context,
                 MaterialPageRoute(builder: (context)=>const WelcomePage()), ModalRoute.withName('/'));
              });
            },child: const Row(
              children: [
                Icon(Icons.logout,color: Colors.black,),
                Text('Log Out'),
              ],
            ),),
            PopupMenuItem(child: 
            Consumer<ThemeProvider>(
  builder: (context, themeProvider, _) {
    return SwitchListTile(
      title: Text('Dark Mode'),
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        themeProvider.toggleTheme();
      },
    );
  },
)
            ,)
          ],
          )
        ],
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
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Groups",
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.search),
      //   onPressed: () {
      //     showModalBottomSheet(
      //       context: context,
      //       builder: (context) => SearchContactPage(),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.vertical(
      //           top: Radius.circular(40),
      //         ),
      //       ),
      //       clipBehavior: Clip.antiAlias,
      //     );
      //   },
      // ),
    );
  }
}
