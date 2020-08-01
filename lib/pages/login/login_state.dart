import 'package:chatdemo/models/Users.dart';
import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {

  final List propss;
  LoginState([this.propss]);

  @override
  List<Object> get props => (propss ?? []);
}

/// UnInitialized
class UnLoginState extends LoginState {

  UnLoginState();

  @override
  String toString() => 'UnLoginState';
}

/// Initialized
class InLoginState extends LoginState {
  final List<Users> users;

  InLoginState(this.users) : super([users]);
  
  // @override
  // String toString() => 'InLoginState $hello';

}

class ErrorLoginState extends LoginState {
  final String errorMessage;

  ErrorLoginState(this.errorMessage): super([errorMessage]);
  
  @override
  String toString() => 'ErrorLoginState';
}
