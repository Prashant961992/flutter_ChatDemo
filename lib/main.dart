import 'package:flutter/material.dart';
import 'package:chatdemo/services/FirebaseAuthorization.dart';
import 'package:chatdemo/pages/RootPage.dart';

import 'FirebaseMessages/PushNotifications.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //init push notification manager
  PushNotificationsManager pushNotificationsManager =
      new PushNotificationsManager();
  pushNotificationsManager.init();
  
  runApp(new MyApp());

  // AppData.sharedInstance.isLogin().whenComplete(() {
  //   Widget _defaultHome = new LoginController();
  //   if (AppData.sharedInstance.loginStatus == AuthStatus.LOGGED_IN) {
  //     _defaultHome = new HomeView();
  //   }

  //   runApp(MyApp(
  //     defaultWidget: _defaultHome,
  //   ));
  // });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter login demo',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new RootPage(auth: new Auth()));
  }
}
