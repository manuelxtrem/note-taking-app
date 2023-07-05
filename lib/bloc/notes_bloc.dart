import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:note_taking_app/data/config_database.dart';
import 'package:note_taking_app/data/note_database.dart';
import 'package:note_taking_app/data/note_repository.dart';
import 'package:note_taking_app/model/editor.dart';
import 'package:note_taking_app/model/note.dart';
import 'package:note_taking_app/res/colors.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesDatabase notesDatabase;
  final ConfigDatabase configDatabase;
  final NotesRepository notesRepository;
  final Connectivity connectivity;

  final List<Note> _allNotes = [];
  List<Note> get allNotes => _allNotes;

  EditorConfig _editorConfig = EditorConfig(mode: EditorMode.view, color: AppColors.background);
  EditorConfig get editorConfig => _editorConfig;

  Note? _currentNote;
  Note? get currentNote => _currentNote;

  bool _isSyncing = false;

  NotesBloc({
    required this.notesDatabase,
    required this.configDatabase,
    required this.notesRepository,
    required this.connectivity,
  }) : super(NotesInitialState()) {
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
      } else if (event is SyncNotesEvent) {
        await _syncNotes(emit);
      }
    });
  }

  Future _getAllnotes(Emitter<NotesState> emit) async {
    final allNotes = notesDatabase.getNotes();
    _allNotes.clear();
    _allNotes.addAll(allNotes);
    _allNotes.sort((a, b) => a.createdAt.isAfter(b.createdAt) ? 0 : 1);

    emit(NotesListState(_allNotes));
  }

  Future _saveNote(Emitter<NotesState> emit, Note note) async {
    notesDatabase.saveNote(note);

    _currentNote = note;
    _editorConfig = _editorConfig.copyWith(mode: EditorMode.view);

    emit(NotesSavedState(note));

    _syncNotes();
  }

  Future _addNote(Emitter<NotesState> emit, Note note) async {
    notesDatabase.addNote(note);

    _editorConfig = _editorConfig.copyWith(mode: EditorMode.view, color: AppColors.background);
    emit(NotesSavedState(note));

    _syncNotes();
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

    final results = notesDatabase.getNotes().where((item) =>
        item.title.toLowerCase().contains(filter) || item.body.toLowerCase().contains(filter));

    emit(FilteredNotesState(results));
  }

  Future _deleteNote(Emitter<NotesState> emit, Note note) async {
    if (_currentNote == note) {
      _currentNote = null;
    }

    notesDatabase.deleteNote(note);

    emit(NotesDeletedState(note));

    _syncNotes();
  }

  Future _syncNotes([Emitter<NotesState>? emit]) async {
    if (_isSyncing) return; // prevent overlap syncing

    _isSyncing = true;

    // freshInstall is when there is no initial data in the DB
    // that way all data from online will be fetched
    try {
      await notesRepository.syncNotes(
        notesDatabase: notesDatabase,
        configDatabase: configDatabase,
        connectivity: connectivity,
        freshInstall: !notesDatabase.hasData(),
      );
    } catch (_) {}

    _isSyncing = false;

    emit?.call(NotesSyncedState());
  }
}
