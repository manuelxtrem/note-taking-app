part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitNotesEvent extends NotesEvent {}

class GetAllNotesEvent extends NotesEvent {}

class SelectNoteEvent extends NotesEvent {
  final Note note;
  final EditorMode? mode;
  final Color? color;

  SelectNoteEvent(this.note, {this.mode, this.color});

  @override
  List<Object?> get props => [note];
}

class AddNoteEvent extends NotesEvent {
  final Note note;

  AddNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class SaveNoteEvent extends NotesEvent {
  final Note note;

  SaveNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class ChangeEditorModeEvent extends NotesEvent {
  final EditorConfig config;

  ChangeEditorModeEvent(this.config);

  @override
  List<Object?> get props => [config];
}

class FilterNotesEvent extends NotesEvent {
  final String filter;

  FilterNotesEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class DeleteNoteEvent extends NotesEvent {
  final Note note;

  DeleteNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class SyncNotesEvent extends NotesEvent {
  SyncNotesEvent();

  @override
  List<Object?> get props => [Random().nextInt(999)];
}
