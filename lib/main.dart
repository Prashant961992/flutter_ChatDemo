import 'dart:io';

import 'package:chatdemo/people_controller.dart';
// import 'package:dart_mongo_lite/dart_mongo_lite.dart';
import 'package:flutter/material.dart';
import 'package:chatdemo/services/FirebaseAuthorization.dart';
import 'package:chatdemo/pages/RootPage.dart';
import 'package:http_server/http_server.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'FirebaseMessages/PushNotifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init push notification manager
  PushNotificationsManager pushNotificationsManager =
      new PushNotificationsManager();
  pushNotificationsManager.init();
  
//   int port = 27017;
//   var server = await HttpServer.bind(InternetAddress.anyIPv4, port);
//   Db db = Db('mongodb://127.0.0.1:27017/test');
//   await db.open();
//   print(server.address);
//   print(server.port);
// // //mongodb+srv://prashant:<password>@cluster0.irytp.gcp.mongodb.net/<dbname>?retryWrites=true&w=majority
//   print('Connected to database');

//   server.transform(HttpBodyHandler()).listen((HttpRequestBody reqBody) async {
//     var request = reqBody.request;
//     var response = request.response;

//     switch (request.uri.path) {
//       case '/':
//         response.write('Hello, World!');
//         await response.close();
//         break;
//       case '/people':
//         PeopleController(reqBody, db);
//         break;
//       default:
//         response
//           ..statusCode = HttpStatus.notFound
//           ..write('Not Found');
//         await response.close();
//     }
//   });

//   print('Server listening');

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
