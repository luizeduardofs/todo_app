import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/src/models/task.dart';
import 'package:todo_app/src/repositories/board_repository.dart';
import 'package:todo_app/src/states/board_state.dart';

class BoardCubit extends Cubit {
  final BoardRepository repository;

  BoardCubit(this.repository) : super(EmptyBoardState());

  Future<void> fetchTasks() async {
    emit(LoadingBoardState());
    try {
      final tasks = await repository.fetch();
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureTasksBoardState(message: 'Something wrong not be right'));
    }
  }

  Future<void> addTask(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;

    tasks.add(newTask);

    await _emitTasks(tasks);
  }

  Future<void> removeTasks(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;

    tasks.remove(newTask);

    await _emitTasks(tasks);
  }

  Future<void> checkTasks(Task newTask) async {
    final tasks = _getTasks();
    if (tasks == null) return;

    final index = tasks.indexOf(newTask);
    tasks[index] = newTask.copyWith(check: !newTask.check);

    await _emitTasks(tasks);
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) {
    emit(GettedTasksBoardState(tasks: tasks));
  }

  List<Task>? _getTasks() {
    final state = this.state;
    if (state is! GettedTasksBoardState) return null;
    return state.tasks.toList();
  }

  Future<void> _emitTasks(List<Task> tasks) async {
    try {
      await repository.update(tasks);
      emit(GettedTasksBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureTasksBoardState(message: 'Something wrong not be right'));
    }
  }
}
