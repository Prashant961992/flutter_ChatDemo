import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  final List propss;
  AuthenticationState([this.propss]);

  @override
  List<Object> get props => (propss ?? []);
}

class AuthenticationInitial extends AuthenticationState {

}

class AuthenticationSuccess extends AuthenticationState {
  final String uId;

  AuthenticationSuccess(this.uId);

  @override
  List<Object> get props => [uId];

  @override
  String toString() => 'AuthenticationSuccess { displayName: $uId }';
}

class AuthenticationFailure extends AuthenticationState {

}


class AuthenticationInProgress extends AuthenticationState {
  
}
