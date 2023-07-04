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
  final EditorMode mode;

  NoteSelectedState(this.note, this.mode);

  @override
  List<Object?> get props => [note, mode];
}

class EditorModeChangedState extends NotesState {
  final EditorMode mode;

  EditorModeChangedState(this.mode);

  @override
  List<Object?> get props => [mode];
}

class FilteredNotesState extends NotesState {
  final Iterable<Note> results;

  FilteredNotesState(this.results);

  @override
  List<Object?> get props => [Random().nextInt(10)];
}
