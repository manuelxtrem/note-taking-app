import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app/bloc/notes_bloc.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/icons.dart';
import 'package:note_taking_app/res/styles.dart';
import 'package:note_taking_app/res/utils.dart';
import 'package:note_taking_app/ui/common/about_dialog.dart';
import 'package:note_taking_app/ui/common/button.dart';
import 'package:note_taking_app/ui/common/dialogs.dart';
import 'package:note_taking_app/ui/common/empty_list.dart';
import 'package:note_taking_app/ui/common/note_list.dart';
import 'package:note_taking_app/ui/pages/editor_screen.dart';
import 'package:note_taking_app/ui/pages/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with DidBuild {
  late NotesBloc _notesBloc;

  @override
  void didBuild(BuildContext context) {
    _notesBloc.add(GetAllNotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    _notesBloc = context.read<NotesBloc>();

    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {
        if (state is NotesInitialState) {
          _notesBloc.add(GetAllNotesEvent());
        } else if (state is NotesDeletedState) {
          _notesBloc.add(GetAllNotesEvent());
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
              onPressed: () {
                _notesBloc.add(ChangeEditorModeEvent(EditorMode.add));
                Navigator.of(context).push(Utils.pageRoute(const EditorScreen()));
              },
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
                onPressed: () {
                  Navigator.of(context).push(Utils.pageRoute(const SearchScreen()));
                },
              ),
              const SizedBox(width: 20),
              AppIconButton(
                icon: AppIcon.info,
                onPressed: () {
                  Dialogs.showWidgetDialog(context, const InfoDialog());
                },
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
