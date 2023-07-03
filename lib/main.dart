import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_taking_app/bloc/notes_bloc.dart';
import 'package:note_taking_app/model/note_adapter.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/ui/pages/home_screen.dart';

void main() {
  Hive.registerAdapter(NoteAdapter());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Taking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.grey,
          background: AppColors.background,
          primary: AppColors.white,
        ),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => NotesBloc()),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
