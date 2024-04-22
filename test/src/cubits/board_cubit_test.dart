import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/src/cubits/board_cubit.dart';
import 'package:todo_app/src/models/task.dart';
import 'package:todo_app/src/repositories/board_repository.dart';
import 'package:todo_app/src/states/board_state.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;

  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository);
  });

  group('fetchTasks |', () {
    test('it should return all tasks', () async {
      when(() => repository.fetch()).thenAnswer((_) async => []);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<LoadingBoardState>(),
          isA<GettedTasksBoardState>(),
        ]),
      );
      await cubit.fetchTasks();
    });

    test('it should return an error when fetch tasks failure', () async {
      when(() => repository.fetch())
          .thenThrow(Exception('Something wrong not be right'));

      expect(
        cubit.stream,
        emitsInOrder([
          isA<LoadingBoardState>(),
          isA<FailureTasksBoardState>(),
        ]),
      );
      await cubit.fetchTasks();
    });
  });

  group('addTasks |', () {
    test('it should add a task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      expect(
        cubit.stream,
        emits(isA<GettedTasksBoardState>()),
      );
      const task = Task(id: 1, description: 'description');
      await cubit.addTask(task);

      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks, [task]);
    });

    test('it should return an error when add tasks failure', () async {
      when(() => repository.update(any()))
          .thenThrow(Exception('Something wrong not be right'));

      expect(
        cubit.stream,
        emits(isA<FailureTasksBoardState>()),
      );

      const task = Task(id: 1, description: 'description');
      await cubit.addTask(task);
    });
  });

  group('removeTasks |', () {
    test('it should remove a task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      const task = Task(id: 1, description: 'description');
      cubit.addTasks([task]);

      expect((cubit.state as GettedTasksBoardState).tasks.length, 1);

      expect(
        cubit.stream,
        emits(isA<GettedTasksBoardState>()),
      );

      await cubit.removeTasks(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 0);
    });

    test('it should return an error when remove tasks failure', () async {
      when(() => repository.update(any()))
          .thenThrow(Exception('Something wrong not be right'));

      const task = Task(id: 1, description: 'description');
      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emits(isA<FailureTasksBoardState>()),
      );

      await cubit.removeTasks(task);
    });
  });

  group('checkTasks |', () {
    test('it should check some task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      const task = Task(id: 1, description: 'description');
      cubit.addTasks([task]);

      expect((cubit.state as GettedTasksBoardState).tasks.length, 1);
      expect((cubit.state as GettedTasksBoardState).tasks.first.check, false);

      expect(
        cubit.stream,
        emits(isA<GettedTasksBoardState>()),
      );

      await cubit.checkTasks(task);
      final state = cubit.state as GettedTasksBoardState;
      expect(state.tasks.length, 1);
      expect(state.tasks.first.check, true);
    });

    test('it should return an error when check tasks failure', () async {
      when(() => repository.update(any()))
          .thenThrow(Exception('Something wrong not be right'));

      const task = Task(id: 1, description: 'description');
      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emits(isA<FailureTasksBoardState>()),
      );

      await cubit.checkTasks(task);
    });
  });
}
