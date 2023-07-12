import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
bool isLoaded=false;

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _currentIndex = 0;
  final PageController _pageController = PageController();


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
      debugPrint("app life cycle resume");
      if(cid!='') {
        RemoteServices().updateUser(cid, {'isOnline':true});
      }
    }
    else {
      debugPrint("app life cycle exit");
      if(cid!='') {
        RemoteServices().updateUser(cid,{'isOnline':false, 'lastOnline':DateTime.now().toIso8601String()});
      }

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
          PopupMenuButton<ListTile>(itemBuilder: (context)=>[
             PopupMenuItem(
             onTap: (){
                 WidgetsBinding.instance.addPostFrameCallback((_) {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>const CurrentUserProfilePage()));
                 });
             },
               child:   ListTile(
                 leading:SizedBox(
                   height: 30,
                   width: 30,
                   child: CircleAvatar(
                     foregroundImage: NetworkImage((isLoaded)?curUser!.photoUrl!:
                     "https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1"

                     ),
                   ),
                 ),
                 title: const Text('Account',),
               ),

            ),
            const PopupMenuDivider(height: 2,),

            PopupMenuItem(
                onTap: (){
              WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const NewGroupPage()));
              });
                },child: const ListTile(
                leading: Icon(Icons.group,color: Colors.black,),
                title: Text('New Group'),
              ),
            ),
            const PopupMenuDivider(),

            PopupMenuItem(child: 
            Consumer<ThemeProvider>(
  builder: (context, themeProvider, _) {
    return SwitchListTile(
      title: const Text('Dark Mode'),
      value: themeProvider.isDarkMode,
      onChanged: (value)  async {
        themeProvider.toggleTheme();
        await const FlutterSecureStorage().write(key: 'theme_preference',value: value.toString());
      },
    );
  },
)
            ,),
            const PopupMenuDivider(),
            PopupMenuItem(

              child: Consumer<ThemeProvider>(
                builder: (context,themeProvider,_){
                return  ListTile(
                  onTap: () async {
                    if(themeProvider.isDarkMode){
                      themeProvider.toggleTheme();
                      await const FlutterSecureStorage().write(key: 'theme_preference',value: false.toString());
                    }

                      await RemoteServices().updateUser(cid,
                        {'token': null,'isOnline':false,'lastOnline':DateTime.now().toIso8601String()},

                      );
                      cid='';

                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context)=>const WelcomePage()), ModalRoute.withName('/'));
                  },
                    leading: Icon(Icons.logout,color: Colors.black,),
                    title: Text('Log Out'),
                  );}
              ))

          ],
          )
        ],
        flexibleSpace: Builder(
          builder: (context) {
            final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: (themeProvider.isDarkMode?[
                    const Color.fromARGB(255, 6, 30, 57),
                    const Color.fromARGB(255, 0, 34, 70),
                  ]:[
                    Colors.blue.shade800,
                    const Color.fromARGB(255, 0, 102, 212),
                  ]),
                ),
              ),
            );
          }
        ),
      ),
      body: StreamBuilder(
          stream:RemoteServices().getUserStream(cid),
          builder: (context,snapshot){
            if(snapshot.hasData){
              curUser=snapshot.data;
              debugPrint('printing again ${curUser!.id} ');
              return PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: _pages,
              );
            }

            return const CircularProgressIndicator();
          }),
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
