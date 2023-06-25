import 'package:flutter/material.dart';
import 'package:realtime_messaging/screens/search_contacts.dart';

import 'my_chats.dart';
import 'my_groups.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = [
    ChatsPage(),
    GroupsPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chatrix",style: TextStyle(fontFamily: "Caveat",fontSize: 40),),
      automaticallyImplyLeading: false,
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
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          });
        },
        items: [
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
