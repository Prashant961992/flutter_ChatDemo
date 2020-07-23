import 'package:chatdemo/models/Users.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AppData {
  AppData._();
  static final AppData sharedInstance = AppData._();
  var currentUserdata = Users();
  String currentUserId = "";
  List<Users> users = [];
}