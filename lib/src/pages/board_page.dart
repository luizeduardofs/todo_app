import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/src/cubits/board_cubit.dart';
import 'package:todo_app/src/models/task.dart';
import 'package:todo_app/src/states/board_state.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  void addTaskDialog() {
    String description = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Sair'),
            ),
            FilledButton(
              onPressed: () {
                final task = Task(id: -1, description: description);
                context.read<BoardCubit>().addTask(task);
                Navigator.pop(context);
              },
              child: const Text('Criar'),
            ),
          ],
          title: const Text('Adicionar uma task'),
          content: TextField(
            onChanged: (value) => description = value,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BoardCubit>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BoardCubit>();
    final state = cubit.state;

    Widget body = Container();

    if (state is EmptyBoardState) {
      body = const Center(
        key: Key('EmptyState'),
        child: Text('Adicione uma nova task'),
      );
    } else if (state is GettedTasksBoardState) {
      final tasks = state.tasks;
      body = ListView.builder(
        key: const Key('GettedState'),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GestureDetector(
            onLongPress: () => cubit.removeTasks(task),
            child: CheckboxListTile(
              value: task.check,
              title: Text(task.description),
              onChanged: (value) {
                cubit.checkTasks(task);
              },
            ),
          );
        },
      );
    } else if (state is FailureTasksBoardState) {
      body = const Center(
        key: Key('FailureState'),
        child: Text('Falha ao pegar as Tasks'),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: body,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => addTaskDialog(),
      ),
    );
  }
}
