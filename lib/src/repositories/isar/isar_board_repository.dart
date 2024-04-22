import 'package:todo_app/src/models/task.dart';
import 'package:todo_app/src/repositories/board_repository.dart';
import 'package:todo_app/src/repositories/isar/isar_datasource.dart';
import 'package:todo_app/src/repositories/isar/task_model.dart';

class IsarBoardRepository implements BoardRepository {
  final IsarDataSource datasource;

  IsarBoardRepository(this.datasource);

  @override
  Future<List<Task>> fetch() async {
    final models = await datasource.getTasks();
    return models
        .map((e) => Task(
              id: e.id,
              description: e.description,
              check: e.check,
            ))
        .toList();
  }

  @override
  Future<List<Task>> update(List<Task> tasks) async {
    final models = tasks.map((e) {
      final model = TaskModel()
        ..check = e.check
        ..description = e.description;
      if (e.id != -1) {
        model.id = e.id;
      }
      return model;
    }).toList();

    await datasource.deleteAllTasks();
    await datasource.putAllTasks(models);

    return tasks;
  }
}
