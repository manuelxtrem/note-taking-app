part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

class NotesInitialState extends NotesState {}
class NotesIdleState extends NotesState {}

class NotesListState extends NotesState {
  final List<Note> list;

  NotesListState(this.list);
}
