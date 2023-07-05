part of 'notes_bloc.dart';

@immutable
abstract class NotesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotesInitialState extends NotesState {}

class NotesIdleState extends NotesState {}

class NotesListState extends NotesState {
  final List<Note> list;

  NotesListState(this.list);

  @override
  List<Object?> get props => [list];
}

class NotesSavedState extends NotesState {
  final Note note;

  NotesSavedState(this.note);

  @override
  List<Object?> get props => [note];
}

class NotesDeletedState extends NotesState {
  final Note note;

  NotesDeletedState(this.note);

  @override
  List<Object?> get props => [note];
}

class NoteSelectedState extends NotesState {
  final Note note;
  final EditorConfig config;

  NoteSelectedState(this.note, this.config);

  @override
  List<Object?> get props => [note, config];
}

class EditorModeChangedState extends NotesState {
  final EditorConfig config;

  EditorModeChangedState(this.config);

  @override
  List<Object?> get props => [config];
}

class FilteredNotesState extends NotesState {
  final Iterable<Note> results;

  FilteredNotesState(this.results);

  @override
  List<Object?> get props => [results];
}

class NotesSyncedState extends NotesState {
  NotesSyncedState();
}
