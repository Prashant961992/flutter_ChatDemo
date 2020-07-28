import 'dart:async';
import 'dart:developer' as developer;

import 'package:chatdemo/models/Users.dart';

import '../login/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginEvent {
  Stream<LoginState> applyAsync(
      {LoginState currentState, LoginBloc bloc});
}

class UnLoginEvent extends LoginEvent {
  @override
  Stream<LoginState> applyAsync({LoginState currentState, LoginBloc bloc}) async* {
    yield UnLoginState();
  }
}

class LoadLoginEvent extends LoginEvent {
  final String username;
  final String password;

  LoadLoginEvent({
    @required this.username,
    @required this.password,
  });

  @override
  Stream<LoginState> applyAsync(
      {LoginState currentState, LoginBloc bloc}) async* {
    try {
      yield UnLoginState();
      await Future.delayed(Duration(seconds: 1));
      yield InLoginState([Users()]);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadLoginEvent', error: _, stackTrace: stackTrace);
      yield ErrorLoginState( _?.toString());
    }
  }
}
