import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_taking_app/bloc/login_bloc.dart';
import 'package:note_taking_app/bloc/notes_bloc.dart';
import 'package:note_taking_app/data/config_database.dart';
import 'package:note_taking_app/data/note_database.dart';
import 'package:note_taking_app/data/note_repository.dart';
import 'package:note_taking_app/model/note.dart';
import 'package:note_taking_app/model/note_adapter.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/constants.dart';
import 'package:note_taking_app/ui/pages/home_screen.dart';
import 'package:note_taking_app/ui/pages/login_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive box and adapters
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>(Constants.notesBox);
  await Hive.openBox(Constants.configBox);

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _notesDb = NotesDatabase();
  final _configDb = ConfigDatabase();
  final _notesRepo = NotesRepository();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotesBloc(
            configDatabase: _configDb,
            notesDatabase: _notesDb,
            notesRepository: _notesRepo,
            connectivity: Connectivity(),
          ),
        ),
        BlocProvider(
          create: (context) => LoginBloc(
            firebaseAuth: _firebaseAuth,
            configDatabase: _configDb,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Note Taking App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.grey,
            background: AppColors.background,
            primary: AppColors.white,
          ),
          useMaterial3: true,
        ),
        home: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            final loginBloc = context.read<LoginBloc>();

            if (loginBloc.isLoggedIn) return const HomeScreen();

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
