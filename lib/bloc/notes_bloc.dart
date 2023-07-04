import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:note_taking_app/model/editor.dart';
import 'package:note_taking_app/model/note.dart';
import 'package:note_taking_app/res/colors.dart';
import 'package:note_taking_app/res/constants.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  late Box<Note> _box;
  final List<Note> _allNotes = [];
  List<Note> get allNotes => _allNotes;

  EditorConfig _editorConfig = EditorConfig(mode: EditorMode.view, color: AppColors.background);
  EditorConfig get editorConfig => _editorConfig;

  Note? _currentNote;
  Note? get currentNote => _currentNote;

  NotesBloc() : super(NotesInitialState()) {
    _initialize();

    on<NotesEvent>((event, emit) async {
      if (event is GetAllNotesEvent) {
        await _getAllnotes(emit);
      } else if (event is SelectNoteEvent) {
        await _selectNote(emit, event.note, mode: event.mode, color: event.color);
      } else if (event is SaveNoteEvent) {
        await _saveNote(emit, event.note);
      } else if (event is AddNoteEvent) {
        await _addNote(emit, event.note);
      } else if (event is ChangeEditorModeEvent) {
        await _changeEditorMode(emit, event.config);
      } else if (event is FilterNotesEvent) {
        await _filterNotes(emit, event.filter);
      } else if (event is DeleteNoteEvent) {
        await _deleteNote(emit, event.note);
      }
    });
  }

  Future _initialize() async {
    _box = Hive.box<Note>(Constants.notesBox);
  }

  Future _getAllnotes(Emitter<NotesState> emit) async {
    _allNotes.clear();
    _allNotes.addAll(_box.values);
    _allNotes.sort((a, b) => a.createdAt.isAfter(b.createdAt) ? 0 : 1);

    emit(NotesListState(_allNotes));
  }

  Future _saveNote(Emitter<NotesState> emit, Note note) async {
    await _box.delete(note.id);
    await _box.put(note.id, note);

    _currentNote = note;
    _editorConfig = _editorConfig.copyWith(mode: EditorMode.view);

    emit(NotesSavedState(note));
  }

  Future _addNote(Emitter<NotesState> emit, Note note) async {
    await _box.put(note.id, note);

    _editorConfig = _editorConfig.copyWith(mode: EditorMode.view, color: AppColors.background);
    emit(NotesSavedState(note));
  }

  Future _selectNote(Emitter<NotesState> emit, Note note, {EditorMode? mode, Color? color}) async {
    _currentNote = note;
    if (mode != null) {
      _editorConfig = _editorConfig.copyWith(mode: mode, color: color);
    }

    emit(NoteSelectedState(note, _editorConfig));
  }

  Future _changeEditorMode(Emitter<NotesState> emit, EditorConfig config) async {
    if (config.mode == EditorMode.add) {
      _currentNote = null;
    }

    _editorConfig = config;

    emit(EditorModeChangedState(config));
  }

  Future _filterNotes(Emitter<NotesState> emit, String filter) async {
    if (filter.isEmpty) {
      emit(FilteredNotesState(const []));
      return;
    }

    final results = _box.values.where((item) =>
        item.title.toLowerCase().contains(filter) || item.body.toLowerCase().contains(filter));

    emit(FilteredNotesState(results));
  }

  Future _deleteNote(Emitter<NotesState> emit, Note note) async {
    if (_currentNote == note) {
      _currentNote = null;
    }

    _box.delete(note.id);

    emit(NotesDeletedState(note));
  }
}
