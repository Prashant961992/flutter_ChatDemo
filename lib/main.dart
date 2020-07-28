// import 'package:dart_mongo_lite/dart_mongo_lite.dart';
import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/pages/HomePage.dart';
import 'package:chatdemo/pages/LoginSignupPage.dart';
import 'package:chatdemo/pages/authentication/index.dart';
import 'package:chatdemo/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatdemo/services/FirebaseAuthorization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'FirebaseMessages/PushNotifications.dart';
import 'LoadingIndicator.dart';
import 'SimpleBlocObserver.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  Bloc.observer = SimpleBlocObserver();
  //init push notification manager
  PushNotificationsManager pushNotificationsManager =
      new PushNotificationsManager();
  pushNotificationsManager.init();

  final authRepository = AuthenticationRepository();
  runApp(BlocProvider<AuthenticationBloc>(
    create: (context) {
      return AuthenticationBloc(authRepository: authRepository)
        ..add(AuthenticationStarted());
    },
    child: MyApp(authRepository: authRepository),
  ));

  // runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final AuthenticationRepository authRepository;

  MyApp({Key key, @required this.authRepository}) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return new MaterialApp(
  //       title: 'Flutter login demo',
  //       debugShowCheckedModeBanner: false,
  //       theme: new ThemeData(
  //         primarySwatch: Colors.blue,
  //       ),
  //       home: new RootPage(auth: new Auth()));
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter login demo',
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationInitial) {
            return SplashScreen();
          } else if (state is AuthenticationSuccess) {
            AppData.sharedInstance.currentUserId = state.uId;
            AppData.sharedInstance.startListner();
            return HomePage(
              userId: state.uId,
              auth: new Auth(),
            );
          } else if (state is AuthenticationFailure) {
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

  void loginCallback() {}
}
