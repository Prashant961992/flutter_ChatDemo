import 'package:flutter/material.dart';
import 'package:chatdemo/pages/home/index.dart';

class HomePages extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: HomeScreen(),
    );
  }
}
