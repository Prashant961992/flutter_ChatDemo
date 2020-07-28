import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import '../login/index.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  
  LoginBloc() : super(UnLoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    try {
      yield* event.applyAsync(currentState: state, bloc: this);
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoginBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }

  @override
  void onChange(Change<LoginState> change) {
    super.onChange(change);
  }
}
