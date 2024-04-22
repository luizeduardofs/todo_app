import 'package:todo_app/src/models/task.dart';

sealed class BoardState {}

class LoadingBoardState implements BoardState {}

class GettedTasksBoardState implements BoardState {
  final List<Task> tasks;

  GettedTasksBoardState({required this.tasks});
}

class EmptyBoardState extends GettedTasksBoardState {
  EmptyBoardState() : super(tasks: []);
}

class FailureTasksBoardState implements BoardState {
  final String message;

  FailureTasksBoardState({required this.message});
}
