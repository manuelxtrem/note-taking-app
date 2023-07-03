import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app/bloc/notes_bloc.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/icons.dart';
import 'package:note_taking_app/res/styles.dart';
import 'package:note_taking_app/ui/common/button.dart';
import 'package:note_taking_app/ui/common/empty_list.dart';
import 'package:note_taking_app/ui/common/note_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late NotesBloc _notesBloc;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is NotesInitialState) {
          print('Initial state');
          _notesBloc = context.read<NotesBloc>();
          _notesBloc.add(InitNotesEvent());
        }
      },
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: Container(
            width: 55,
            height: 55,
            decoration: const BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  offset: Offset(-5, 0),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  offset: Offset(0, 5),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {},
              child: Center(child: AppIcon.add.draw(size: 38)),
            ),
          ),
          appBar: AppBar(
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: const Text('Notes', style: AppStyle.headline1),
            actions: [
              AppIconButton(
                icon: AppIcon.search,
                onPressed: () {},
              ),
              const SizedBox(width: 20),
              AppIconButton(
                icon: AppIcon.info,
                onPressed: () {},
              ),
              const SizedBox(width: 15),
            ],
          ),
          body: (_notesBloc.allNotes.isEmpty)
              ? const EmptyList(text: 'Create your first note !')
              : NotesList(items: _notesBloc.allNotes),
        );
      },
    );
  }
}
