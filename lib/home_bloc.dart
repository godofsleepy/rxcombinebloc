import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxcombinebloc/game.dart';
import 'package:rxcombinebloc/remote.dart';

enum HomeStatus { initial, success, failed, loading }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<Game> games;
  final String message;

  const HomeState({
    this.status = HomeStatus.initial,
    this.games = const [],
    this.message = "",
  });

  @override
  List<Object> get props => [status, games, message];

  HomeState copyWith({
    HomeStatus? status,
    List<Game>? games,
    String? message,
  }) {
    return HomeState(
      status: status ?? this.status,
      games: games ?? this.games,
      message: message ?? this.message,
    );
  }
}

abstract class HomeEvent {}

class GetGames extends HomeEvent {
  final int page;

  GetGames(this.page);
}

class ResultGames extends HomeEvent {
  final List<Game> data;

  ResultGames(this.data);
}

class ErrorGames extends HomeEvent {
  final Object error;

  ErrorGames(this.error);
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final Remote _remote;
  HomeBloc({required Remote remote})
      : _remote = remote,
        super(const HomeState()) {
    on<GetGames>((event, emit) async {
      emit(state.copyWith(
        status: HomeStatus.loading,
      ));
      _remote.getListGame(page: event.page).listen((data) {
        print("on data");
        add(ResultGames(data));
      }, onDone: () {
        print("done");
      }, onError: (e) {
        print(e.toString());
        add(ErrorGames(e));
      });
    });

    on<ResultGames>((event, emit) {
      if (event.data.isNotEmpty) {
        emit(state.copyWith(
          status: HomeStatus.success,
          games: event.data,
        ));
      } else {
        emit(state.copyWith(status: HomeStatus.failed));
      }
    });

    on<ErrorGames>((event, emit) {
      emit(state.copyWith(status: HomeStatus.failed));
    });
  }
}
