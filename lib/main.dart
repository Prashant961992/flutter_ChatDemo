// import 'package:dart_mongo_lite/dart_mongo_lite.dart';
import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/pages/LoginSignupPage.dart';
import 'package:chatdemo/pages/authentication/index.dart';
import 'package:chatdemo/pages/splash_screen.dart';
import 'package:device_simulator/device_simulator.dart';
import 'utils/index.dart';
import 'package:flutter/material.dart';
import 'package:chatdemo/services/FirebaseAuthorization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'FirebaseMessages/PushNotifications.dart';
import 'LoadingIndicator.dart';
import 'SimpleBlocObserver.dart';
import 'pages/tabbar.dart';

const bool debugEnableDeviceSimulator = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleBlocObserver();
  //init push notification manager
  // PushNotificationsManager pushNotificationsManager =
  //     new PushNotificationsManager();
  // pushNotificationsManager.init();

  final authRepository = AuthenticationRepository();
  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      return AuthenticationBloc(authRepository: authRepository)
        ..add(AuthenticationStarted());
    },
    child: MyApp(authRepository: authRepository),
  ));
}

class MyApp extends StatefulWidget {
  final AuthenticationRepository authRepository;

  MyApp({Key key, @required this.authRepository}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("APP_STATE: $state");

    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      AppData.instance.makeOnline(true, AppData.instance.currentUserId);
    } else if (state == AppLifecycleState.inactive) {
      // app is inactive
    } else if (state == AppLifecycleState.paused) {
      // user quit our app temporally
      AppData.instance.makeOnline(false, AppData.instance.currentUserId);
    } else if (state == AppLifecycleState.detached) {
      // app suspended
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: skyMaterialColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      title: 'Flutter login demo',
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationInitial) {
            return SplashScreen();
          } else if (state is AuthenticationSuccess) {
            AppData.instance.currentUserId = state.uId;
            // AppData.instance.startListner();
            return MyTabbedPage();
          } else if (state is AuthenticationFailure) {
            // if (AppData.instance.currentUserId.length > 0) {
            //    AppData.instance.makeOnline(false, AppData.instance.currentUserId);
            // }
            // AppData.instance.currentUserId = "";
            //AppData.instance.dispose();
            return LoginSignupPage(
              auth: new Auth(),
            );
          } else if (state is AuthenticationInProgress) {
            return LoadingIndicator();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
// class MyApp extends StatelessWidget with WidgetsBindingObserver {
//   final AuthenticationRepository authRepository;

//   MyApp({Key key, @required this.authRepository}) : super(key: key);

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // user returned to our app
//     } else if (state == AppLifecycleState.inactive) {
//       // app is inactive
//     } else if (state == AppLifecycleState.paused) {
//       // user is about quit our app temporally
//     } else if (state == AppLifecycleState.detached) {
//       // app suspended (not used in iOS)
//     }
//   }

//   // @override
//   // Widget build(BuildContext context) {
//   //   return new MaterialApp(
//   //       title: 'Flutter login demo',
//   //       debugShowCheckedModeBanner: false,
//   //       theme: new ThemeData(
//   //         primarySwatch: Colors.blue,
//   //       ),
//   //       home: new RootPage(auth: new Auth()));
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter login demo',
//       debugShowCheckedModeBanner: false,
//       home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//         builder: (context, state) {
//           if (state is AuthenticationInitial) {
//             return SplashScreen();
//           } else if (state is AuthenticationSuccess) {
//             AppData.sharedInstance.currentUserId = state.uId;
//             AppData.sharedInstance.startListner();
//             return HomePage(
//               userId: state.uId,
//               auth: new Auth(),
//             );
//           } else if (state is AuthenticationFailure) {
//             return LoginSignupPage(
//               auth: new Auth(),
//             );
//           } else if (state is AuthenticationInProgress) {
//             return LoadingIndicator();
//           } else {
//             return Container();
//           }
//         },
//       ),
//     );
//   }

//   void loginCallback() {}
// }
