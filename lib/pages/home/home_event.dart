import 'dart:async';
import 'dart:developer' as developer;

import 'package:chatdemo/pages/home/index.dart';
import 'package:meta/meta.dart';

@immutable
abstract class HomeEvent {
  Stream<HomeState> applyAsync(
      {HomeState currentState, HomeBloc bloc});
  // final HomeRepository _homeRepository = HomeRepository();
}

class UnHomeEvent extends HomeEvent {
  @override
  Stream<HomeState> applyAsync({HomeState currentState, HomeBloc bloc}) async* {
    yield UnHomeState();
  }
}

class LoadHomeEvent extends HomeEvent {
  final bool isError;
  @override
  String toString() => 'LoadHomeEvent';

  LoadHomeEvent(this.isError);

  @override
  Stream<HomeState> applyAsync(
      {HomeState currentState, HomeBloc bloc}) async* {
    try {
      yield UnHomeState();
      await Future.delayed(Duration(seconds: 1));
      // _homeRepository.test(isError);
      yield SuccessHomeState('Hello world');
    } catch (_, stackTrace) {
      developer.log('$_', name: 'LoadHomeEvent', error: _, stackTrace: stackTrace);
      yield ErrorHomeState(_?.toString());
    }
  }
}
