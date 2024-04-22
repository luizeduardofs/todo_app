import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/src/cubits/board_cubit.dart';
import 'package:todo_app/src/pages/board_page.dart';
import 'package:todo_app/src/repositories/board_repository.dart';
import 'package:todo_app/src/repositories/isar/isar_board_repository.dart';
import 'package:todo_app/src/repositories/isar/isar_datasource.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(create: (context) => IsarDataSource()),
        RepositoryProvider<BoardRepository>(
            create: (context) => IsarBoardRepository(context.read())),
        BlocProvider(create: (context) => BoardCubit(context.read())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.purple),
        home: const BoardPage(),
      ),
    );
  }
}
