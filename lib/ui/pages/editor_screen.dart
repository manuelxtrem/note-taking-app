// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_app/bloc/notes_bloc.dart';
import 'package:note_taking_app/model/editor.dart';
import 'package:note_taking_app/model/note.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/icons.dart';
import 'package:note_taking_app/res/styles.dart';
import 'package:note_taking_app/res/utils.dart';
import 'package:note_taking_app/ui/common/button.dart';
import 'package:note_taking_app/ui/common/dialogs.dart';
import 'package:uuid/uuid.dart';

class EditorScreen extends StatefulWidget {
  // final EditorMode mode;

  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> with DidBuildMixin {
  bool get _editMode => [EditorMode.add, EditorMode.edit].contains(_notesBloc.editorConfig.mode);

  late NotesBloc _notesBloc;
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _mainFocus = FocusNode();

  bool _changed = false;

  @override
  void didBuild(BuildContext context) {
    _notesBloc.add(GetAllNotesEvent());

    if (_notesBloc.currentNote != null) {
      final note = _notesBloc.currentNote!;
      _titleCtrl.text = note.title;
      _bodyCtrl.text = note.body;
    }

    // delay focus so animations can finish smoothly
    _requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    _notesBloc = context.read<NotesBloc>();

    return WillPopScope(
      onWillPop: () async {
        await _onDiscardNote();
        return false;
      },
      child: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) async {
          if (state is NotesSavedState) {
            final notesBloc = context.read<NotesBloc>();
            notesBloc.add(GetAllNotesEvent());

            await Dialogs.showSingleOptionDialog(context, 'Note has been saved');
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          log('color ${_notesBloc.editorConfig.color}');
          return Hero(
            tag: _notesBloc.currentNote?.id ?? '_new_item',
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                title: AppIconButton(
                  icon: AppIcon.chevron,
                  size: 16,
                  onPressed: () {
                    _onDiscardNote();
                  },
                ),
                leading: const SizedBox(),
                leadingWidth: 0,
                actions: [
                  if (_notesBloc.editorConfig.mode == EditorMode.edit)
                    AppIconButton(
                      icon: AppIcon.eye,
                      onPressed: () => _onViewNote(),
                    ),
                  const SizedBox(width: 20),
                  if (_editMode)
                    AppIconButton(
                      icon: AppIcon.save,
                      onPressed: () => _onSaveNote(),
                    )
                  else
                    AppIconButton(
                      icon: AppIcon.pencil,
                      onPressed: () => _onEditNote(),
                    ),
                  const SizedBox(width: 15),
                ],
              ),
              body: Stack(
                children: [
                  Positioned(
                    child: Container(
                      color:
                          (_notesBloc.editorConfig.color ?? AppColors.background).withOpacity(.08),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextField(
                          controller: _titleCtrl,
                          focusNode: _mainFocus,
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: AppStyle.headline2.copyWith(color: AppColors.textMuted),
                            border: InputBorder.none,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: AppStyle.headline2,
                          enabled: _editMode,
                          onChanged: (text) {
                            log('changing title');
                            _changed = true;
                          },
                        ),
                        TextField(
                          controller: _bodyCtrl,
                          decoration: InputDecoration(
                            hintText: 'Type something...',
                            hintStyle: AppStyle.body2.copyWith(color: AppColors.textMuted),
                            border: InputBorder.none,
                          ),
                          style: AppStyle.body2,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          enabled: _editMode,
                          onChanged: (text) {
                            log('changing body');
                            _changed = true;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onSaveNote() async {
    if (_titleCtrl.text.trim().isEmpty) {
      Dialogs.showSingleOptionDialog(context, 'You must type a title for your note');
      return;
    }
    if (_bodyCtrl.text.trim().isEmpty) {
      Dialogs.showSingleOptionDialog(context, 'You must type a body for your note');
      return;
    }

    final opt1 = await Dialogs.showDoubleOptionDialog(
      context,
      'Save changes ?',
      positiveLabel: 'Save',
      negativeLabel: 'Discard',
    );
    if (opt1 == DialogAction.positive) {
      // adding or editing
      if (_notesBloc.editorConfig.mode == EditorMode.add) {
        Note newNote = Note(
          id: const Uuid().v4(),
          title: _titleCtrl.text,
          body: _bodyCtrl.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final notesBloc = context.read<NotesBloc>();
        notesBloc.add(AddNoteEvent(newNote));
      } else {
        Note editedNote = _notesBloc.currentNote!.copyWith(
          title: _titleCtrl.text,
          body: _bodyCtrl.text,
          updatedAt: DateTime.now(),
        );

        final notesBloc = context.read<NotesBloc>();
        notesBloc.add(SaveNoteEvent(editedNote));
      }
    } else {
      await _onDiscardNote();
    }
  }

  void _onViewNote() async {
    await _onDiscardNote(pop: false);
  }

  Future<void> _onEditNote() async {
    _notesBloc.add(ChangeEditorModeEvent(_notesBloc.editorConfig.copyWith(mode: EditorMode.edit)));
    _requestFocus();
  }

  void _requestFocus() {
    Future.delayed(const Duration(milliseconds: 600), () {
      _mainFocus.requestFocus();
    });
  }

  Future _onDiscardNote({bool pop = true}) async {
    popOrView() {
      if (pop) {
        Navigator.of(context).pop();
      } else {
        _notesBloc
            .add(ChangeEditorModeEvent(_notesBloc.editorConfig.copyWith(mode: EditorMode.view)));
      }
    }

    if (_notesBloc.editorConfig.mode == EditorMode.view) {
      popOrView();
      return;
    }

    if (!_changed) {
      popOrView();
      return;
    }

    final opt = await Dialogs.showDoubleOptionDialog(
      context,
      'Are your sure you want discard your changes ?',
      positiveLabel: 'Keep',
      negativeLabel: 'Discard',
    );
    if (opt == DialogAction.negative) {
      popOrView();
    }
  }
}
