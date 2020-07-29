import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/pages/HomePage.dart';
import 'package:chatdemo/utils/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'profile_screen.dart';

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({Key key}) : super(key: key);
  @override
  _MyTabbedPageState createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage>
    with SingleTickerProviderStateMixin {
  final List<Widget> myTabs = <Widget>[HomePage(), ProfileScreen()];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    AppData.instance.startListner();
    AppData.instance.makeOnline(true, AppData.instance.currentUserId);
   
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // elevation: 80,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled),
            title: Text('Profile'),
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: sky,
        onTap: (value) {
           setState(() {
             currentIndex = value;
           });
        },
      ),
      body: myTabs[currentIndex],
    );
  }

}

  // @override
  // Widget build(BuildContext context) {
  //   return CupertinoTabScaffold(
  //     controller: CupertinoTabController(initialIndex: 0),
  //     tabBar: CupertinoTabBar(
  //       items: const <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(
  //           icon: Icon(Icons.chat),
  //           title: Text('Chat'),
  //         ),
  //         BottomNavigationBarItem(
  //           icon: Icon(CupertinoIcons.profile_circled),
  //           title: Text('Profile'),
  //         ),
  //       ],
  //     ),
  //     tabBuilder: (context, index) {
  //       CupertinoTabView returnValue;
  //       switch (index) {
  //         case 0:
  //           returnValue = CupertinoTabView(builder: (context) {
  //             return CupertinoPageScaffold(
  //               child: HomePage(),
  //             );
  //           });
  //           break;
  //         case 1:
  //           returnValue = CupertinoTabView(builder: (context) {
  //             return CupertinoPageScaffold(
  //               child: ProfileScreen(),
  //             );
  //           });
  //           break;
  //       }
  //       return returnValue;
  //     },
  //   );
  // }

  // Tab Bar
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     bottomNavigationBar: new TabBar(
  //         controller: _tabController,
  //         onTap: (value) {
  //           setState(() {
  //             currentIndex = value;
  //           });
  //         },
  //         tabs: [
  //           Tab(
  //             text: 'Chat',
  //             icon: new Icon(Icons.chat),
  //           ),
  //           Tab(
  //             text: 'Profile',
  //             icon: new Icon(Icons.people),
  //           )
  //         ],
  //         indicatorWeight: 1,
  //         indicatorColor: Colors.transparent,
  //         labelColor: Colors.blue[300],
  //         unselectedLabelColor: Colors.blue[100],
  //       ),
  //     body: myTabs[currentIndex],
  //   );
  // }
  

