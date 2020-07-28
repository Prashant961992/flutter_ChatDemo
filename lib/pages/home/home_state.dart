import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  
  final List propss;
  HomeState([this.propss]);

  @override
  List<Object> get props => (propss ?? []);
}

/// Default Unhome State
class UnHomeState extends HomeState {

  UnHomeState();

  @override
  String toString() => 'UnHomeState';
}

class InProgressHomeState extends HomeState {
  final String message;

  InProgressHomeState(this.message) : super([message]);
}

/// Initialized
class SuccessHomeState extends HomeState {
  final String hello;

  SuccessHomeState(this.hello) : super([hello]);

  @override
  String toString() => 'InHomeState $hello';
}

class ErrorHomeState extends HomeState {
  final String errorMessage;

  ErrorHomeState(this.errorMessage): super([errorMessage]);
  
  @override
  String toString() => 'Error: $errorMessage';
}
